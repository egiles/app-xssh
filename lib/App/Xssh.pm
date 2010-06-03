package App::Xssh;

use Config::General;
use Moose;

our $VERSION = 0.1;
=head1 NAME

App::Xssh - library module to support bin/xssh

=head1 SYNOPSYS

	use App:Xssh;
	
	my $xssh = App:Xssh->new();
	my $data = $xssh->readConfig();
	
	$xssh->addToConfig(["location","path"],"setting","value");
	$xssh->saveConfig();
=cut


=head1 METHODS

=over
=cut
sub _configFilename {
  return "$ENV{HOME}/.xsshrc";
}

sub _openConfig {
  my ($self) = @_;

  if ( ! $self->{ConfigGeneral} ) {
    my $filename = _configFilename();

    if ( ! -f $filename ) {
      if ( ! open(my $temp, ">", $filename) ) {
        return;
      }
    }
    $self->{ConfigGeneral} = Config::General->new($filename);
  }

  return $self->{ConfigGeneral};
}

=item readConfig()
=cut
sub readConfig {
  my ($self) = @_;

  if ( ! $self->{data} ) {
    my $conf = $self->_openConfig();
    $self->{data} = { $conf->getall() };
  }

  return $self->{data};
}

=item addToConfig()
=cut
sub addToConfig {
  my ($self,$path,$attr,$value) = @_;

  my $config = $self->readConfig();

  my $curr = $config;
  for my $key ( @$path ) {
    if ( ! defined($curr->{$key}) ) {
      $curr->{$key} = {};
    }
    $curr = $curr->{$key};
  }
  $curr->{$attr} = $value;
}

=item saveConfig()
=cut
sub saveConfig{
  my ($self) = @_;

  my $data = $self->readConfig();
  my $conf = $self->_openConfig();
  $conf->save_file(_configFilename(),$data);
}

=back

=head1 COPYRIGHT
Copyright 2010 Evan Giles.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
=cut

1; # End of App:Xssh
