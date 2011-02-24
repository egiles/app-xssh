use strict;
use warnings;

use Test::More;
use File::Temp;

use_ok("App::Xssh");
use_ok("App::Xssh::Config");

# Arrange for a safe place to play
$ENV{HOME} = File::Temp::tempdir( CLEANUP => 1 );

my $xssh = App::Xssh::Config->new();

# Create some profile attributes to define the FG/BG
$xssh->add(["profile","local","foreground"],"red");
$xssh->add(["profile","trusted","background"],"red");

# Create a host entry that references both profile attributes
$xssh->add(["hosts","testhost","profile"],"local,trusted");

# See that the attribute contains the FG and the BG options
my $options = App::Xssh::getTerminalOptions($xssh,"testhost");
ok($options->{foreground} eq "red", "foreground option");
ok($options->{background} eq "red", "background option");

done_testing();
