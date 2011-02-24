package App::Xssh;

use strict;
use warnings;

use 5.6.0;

use Getopt::Long;
use Pod::Usage;
use App::Xssh::Config;

our $VERSION = 0.5;

=head1 NAME

App::Xssh - Encapsulates the application logic for xssh

=head1 SYNOPSYS

	use App::Xssh;
	
	App::Xssh::main();
=cut

=head1 FUNCTIONS

=over

=item upgradeConfig()

Remove deprecation from the config data, if it changes anything it will
also write the config file back to disk.

The deprecations are:

=over

=item Rename the 'extra' attribute to 'profile' (since v0.5)

=back
=cut
sub upgradeConfig {
  my ($config,$data) = @_;

  my $rename = sub {
      my ($data,$src,$dst) = @_;
      if ( my $value = delete $data->{$src->[0]}->{$src->[1]}->{$src->[2]} ) {
        $data->{$dst->[0]}->{$dst->[1]}->{$dst->[2]} = $value;
        $config->add($dst,$value);
        $config->delete($src);
        $config->write();
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

  return $data;
}

=item getTerminalOptions()

Reads the config data and determines the options that should be applied 
for a given host
=cut
sub getTerminalOptions {
  my ($config,$host) = @_;

  my $data = upgradeConfig($config,$config->read());

  my $options = $data->{hosts}->{DEFAULT} || {};

  if ( my $details = $data->{hosts}->{$host} ) {
    $options = { %$options, %{$data->{hosts}->{$host}} };
  }

  while ( my $value = delete $options->{profile} ) {
    for my $profile ( split(/,/,$value) ) {
      if ( my $details = $data->{profile}->{$profile} ) {
        $options = { %$options, %{$data->{profile}->{$profile}} };
      }
    }
  }

  $options->{host} = $host;
  return($options);
}

=item launchTerminal()

Calls the X11::Terminal class to launch an X11 terminal emulator
=cut
sub launchTerminal {
  my ($options) = @_;

  my $type = $options->{type} || "XTerm";
  my $class = "X11::Terminal::$type";
  eval "require $class";
  my $term = $class->new(%$options);
  $term->launch();
}

=item setValue()

Sets a value in the config, and writes the config out
=cut
sub setValue {
  my ($config,$category,$name,$option,$value) = @_;

  if ( ! ($name && $option && $value) ) {
    pod2usage(1);
  }

  $config->add([$category,$name,$option],$value);
  $config->write();
}

=item main()

This is the entry point for the xssh script.  It parses the command line
and calls the appropraite application behaviour.

=back
=cut
sub main {
  my $sethost;
  my $setprofile;
  my $showconfig;
  GetOptions(
    'sethostopt' => \$sethost,
    'setprofileopt' => \$setprofile,
    'showconfig' => \$showconfig,
  ) or pod2usage(1);
  
  my $config = App::Xssh::Config->new();
  if ( $sethost ) {
    setValue($config,"hosts",@ARGV);
    return 1;
  }
  if ( $setprofile ) {
    setValue($config,"profile",@ARGV);
    return 1;
  }
  if ( $showconfig ) {
    print $config->show($config);
    return 1;
  }

  if ( my ($host) = @ARGV ) {
    my $options = getTerminalOptions($config,$host);
    return launchTerminal($options);;
  }
}

=head1 COPYRIGHT & LICENSE

Copyright 2010-2011 Evan Giles.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
=cut

1; # End of App::Xssh
