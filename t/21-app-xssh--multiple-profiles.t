use strict;
use warnings;

use Test::More;
use File::Temp;

use App::Xssh;

# Arrange for a safe place to play
$ENV{HOME} = File::Temp::tempdir( CLEANUP => 1 );

my $xssh = App::Xssh->new();
my $data = {};

# Create some profile attributes to define the FG/BG
$xssh->setConfig($data, "profile/local/foreground/red");
$xssh->setConfig($data, "profile/trusted/background/red");

# Create a host entry that references both profile attributes
$xssh->setConfig($data, "hosts/testhost/profile/local,trusted");

# See that the attribute contains the FG and the BG options
my $options = $xssh->getTerminalOptions($data,"testhost");
ok($options->{foreground} eq "red", "foreground option");
ok($options->{background} eq "red", "background option");

done_testing();
