package App::Xssh;

use strict;
use warnings;

use Config::General;

our $VERSION = 0.2;
=head1 NAME

App::Xssh - Encapsulates the configuration for xssh - using Config::General

=head1 SYNOPSYS

	use App:Xssh;
	
	my $xssh = App:Xssh->new();
	my $data = $xssh->readConfig();
	
	$xssh->addToConfig(["location","path","setting"],"value");
	$xssh->saveConfig();
=cut

=head1 METHODS

=over

=item new()

Construcor, just used to provide an object with access to the methods
=cut
sub new {
   my $class = shift;
   return bless {}, $class;
}

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

Reads the config file into memory, returns a hashref pointing to the config data
=cut
sub readConfig {
  my ($self) = @_;

  if ( ! $self->{data} ) {
    my $conf = $self->_openConfig();
    $self->{data} = { $conf->getall() };
  }

  return $self->{data};
}

=item addToConfig($path,$value)

Adds a data to the existing config data - in memory.   

=over

=item $path

An arrayref to the location of the atrribute to be stored.

=item $value

A string to be stored at that location.

=back
=cut
sub addToConfig {
  my ($self,$path,$value) = @_;

  my $attr = pop @$path;

  my $config = $self->readConfig();
  for my $key ( @$path ) {
    if ( ! defined($config->{$key}) ) {
      $config->{$key} = {};
    }
    $config = $config->{$key};
  }
  $config->{$attr} = $value;
}

=item saveConfig()

Writes the current config data back to a config file on disk.  Completely overwrites the existinng file.
=cut
sub saveConfig{
  my ($self) = @_;

  my $data = $self->readConfig();
  my $conf = $self->_openConfig();
  $conf->save_file(_configFilename(),$data);
  return 1;
}

=back

=head1 COPYRIGHT & LICENSE

Copyright 2010 Evan Giles.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
=cut

1; # End of App:Xssh
