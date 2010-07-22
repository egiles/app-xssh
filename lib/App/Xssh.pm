package App::Xssh;

use strict;
use warnings;

use 5.6.0;

use Getopt::Long;
use Pod::Usage;
use App::Xssh::Config;

our $VERSION = 0.4;

=head1 NAME

App::Xssh - Encapsulates the application logic for xssh

=head1 SYNOPSYS

	use App::Xssh;
	
	App::Xssh::main();
=cut

=head1 FUNCTIONS

=over

=item getTerminalOptions()

Reads the config data and determines the attributes that should be applied 
for a given host
=cut
sub getTerminalOptions {
  my ($config,$host) = @_;

  my $data = $config->read();

  my $options = $data->{hosts}->{DEFAULT} || {};

  if ( my $details = $data->{hosts}->{$host} ) {
    $options = { %$options, %{$data->{hosts}->{$host}} };
  }

  while ( my $value = delete $options->{extra} ) {
    for my $extra ( split(/,/,$value) ) {
      if ( my $details = $data->{extra}->{$extra} ) {
        $options = { %$options, %{$data->{extra}->{$extra}} };
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

=item main()

This is the entry point for the xssh script.  It parses the command line
and calls the appropraite application behaviour.
=back
=cut
sub main {
  my $sethost;
  my $setextra;
  my $showconfig;
  GetOptions(
    'sethostattr' => \$sethost,
    'setextraattr' => \$setextra,
    'showconfig' => \$showconfig,
  ) or pod2usage(1);
  
  my $config = App::Xssh::Config->new();
  if ( $sethost ) {
    my ($name,$attr,$value) = @ARGV;
    if ( ! ($name && $attr && $value) ) {
      pod2usage(1);
    }
    $config->add(["hosts",$name,$attr],$value);
    $config->write();
    return 1;
  }
  if ( $setextra ) {
    my ($name,$attr,$value) = @ARGV;
    if ( ! ($name && $attr && $value) ) {
      pod2usage(1);
    }
    $config->add(["extra",$name,$attr],$value);
    $config->write();
    return 1;
  }
  if ( $showconfig ) {
    print $config->show($config);
  }

  if ( my ($host) = @ARGV ) {
    my $options = getTerminalOptions($config,$host);
    return launchTerminal($options);;
  }
}

1;
