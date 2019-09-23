package App::Xssh;

use strict;
use warnings;

use 5.6.0;

use Moose;
use Getopt::Long;
use Pod::Usage;
use UNIVERSAL::require;
use App::Xssh::Config;
use version; our $VERSION = qv("v2.0.0");

=head1 NAME

App::Xssh - Encapsulates the application logic for xssh

=head1 SYNOPSYS

	use App::Xssh;
	
	my $main = App::Xssh->new();
	$main->run();
=cut

=head1 METHODS

=over

=item new()

Construcor, just used to provide an object with access to the methods

=item setConfig()

Adds or updates values in the config file.  Values are defined by parsing a string 
with the format C<path/path/path/value>.  For example C<hosts/hostname/foreground/red>.

=cut
sub setConfig {
  my ($self, $data, $string) = @_;

  my @list = split(/\//, $string);

  # Wouldn't it be great to have a generic algorythum here??
  if ( @list == 2 ) {
    $data->{$list[0]} = $list[1];
  } elsif ( @list == 3 ) {
    $data->{$list[0]}->{$list[1]} = $list[2];
  } elsif ( @list == 4 ) {
    $data->{$list[0]}->{$list[1]}->{$list[2]} = $list[3];
  } elsif ( @list == 5 ) {
    $data->{$list[0]}->{$list[1]}->{$list[2]}->{$list[3]} = $list[4];
  } else {
    print("WTF\n");
  }

  return $data;
}

=item upgradeConfig()

Remove deprecation from the config data, if it changes anything it will
also write the config file back to disk.

The deprecations are:

=over

=item * 

Rename the 'extra' attribute to 'profile' (since v0.5)

=back
=cut
sub upgradeConfig {
  my ($self,$config,$data) = @_;

  if ( ! $data->{configver} ) {
    # This is really legacy stuff, before we ever tried to track the config version
    my $rename = sub {
        my ($name,$src,$dst) = @_;
        if ( my $value = delete $name->{$src->[0]}->{$src->[1]}->{$src->[2]} ) {
          $name->{$dst->[0]}->{$dst->[1]}->{$dst->[2]} = $value;
        }
    };

    # Rename the 'extra' attribute to 'profile'
    for my $host ( keys %{$data->{hosts} } ) {
      $rename->($data,["hosts",$host,"extra"],["hosts",$host,"profile"]);
    }
    if ( $data->{extra} ) {
      my $extra = $data->{extra};
      for my $name ( keys %$extra ) {
        for my $option ( keys %{$extra->{$name}} ) {
          $rename->($data,["extra",$name,$option],["profile",$name,$option]);
        }
      }
    }
    $data->{configver} = 20190920;
    $config->write($data);
  }

  return $data;
}

sub _mergeOptions {
  my ($self,$data,$options,$moreOptions) = @_;

  if ( $moreOptions ) {
    $options = { %$options, %$moreOptions };
  }

  while ( my $value = delete $options->{profile} ) {
    for my $profile ( split(/,/,$value) ) {
      if ( my $details = $data->{profile}->{$profile} ) {
        $options = { %$options, %{$data->{profile}->{$profile}} };
      }
    }
  }

  return $options;
}

=item getTerminalOptions()

Reads the config data and determines the options that should be applied 
for a given host
=cut
sub getTerminalOptions {
  my ($self, $data, $host) = @_;

  my $options = {};

  # Begin with the DEFAULT options
  $options = $self->_mergeOptions($data,$options,$data->{hosts}->{DEFAULT});

  # Add in any hosts that match
  for my $hostmatch ( keys %{$data->{hosts}} ) {
    if ( $host =~ m/^$hostmatch$/ ) {
      $options = $self->_mergeOptions($data,$options,$data->{hosts}->{$hostmatch});
    }
  }

  # Finish with the specified host
  if ( my $details = $data->{hosts}->{$host} ) {
    $options = $self->_mergeOptions($data,$options,$data->{hosts}->{$host});
  }

  $options->{host} = $host;
  return($options);
}

=item launchTerminal()

Calls the X11::Terminal class to launch an X11 terminal emulator
=cut
sub launchTerminal {
  my ($self,$options) = @_;

  my $type = $options->{type} || "XTerm";
  my $class = "X11::Terminal::$type";
  if ( $class->require ) {
      my $term = $class->new(%$options);
      return $term->launch();
  }
}

=item run()

This is the entry point for the xssh script.  It parses the command line
and calls the appropraite application behaviour.

=back
=cut
sub run {
  my ($self) = @_;

  my $options = {};
  GetOptions(
     $options,
    'setconfig',
    'showconfig',
    'version'
  ) or pod2usage(1);
  
  my $config = App::Xssh::Config->new();
  my $data = $self->upgradeConfig($config,$config->read());

  if ( $options->{setconfig} ) {
    $data = $self->setConfig($data, @ARGV);
    $config->write($data);
    return 1;
  }
  if ( $options->{showconfig} ) {
    print $config->show();
    return 1;
  }
  if ( $options->{version} ) {
    print "Version: $VERSION\n";
    return 1;
  }

  if ( my ($host) = @ARGV ) {
    my $options = $self->getTerminalOptions($data,$host);
    return $self->launchTerminal($options);;
  }
}

=head1 COPYRIGHT & LICENSE

Copyright 2010-2019 Evan Giles.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
=cut

1; # End of App::Xssh
