use strict;
use warnings;

use Test::More 'no_plan';
use File::Temp;

use App::Xssh;

# Load the script as a module
require_ok("bin/xssh");

# Create a temporary config object, so we can mess with it
my $xssh = App::Xssh->new();

# Create some extra attributes to define the FG/BG
$xssh->addToConfig(["extra","local","foreground"],"red");
$xssh->addToConfig(["extra","trusted","background"],"red");

# Create a host entry that references both extra attributes
$xssh->addToConfig(["hosts","testhost","extra"],"local,trusted");

# See that the attribute contains the FG and the BG options
my $options = getTerminalOptions($xssh,"testhost");
ok($options->{foreground} eq "red", "foreground option");
ok($options->{background} eq "red", "background option");
