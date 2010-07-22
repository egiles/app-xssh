use strict;
use warnings;

use Test::More;
use File::Temp;

use_ok("App::Xssh");
use_ok("App::Xssh::Config");

# Create a temporary config object, so we can mess with it
my $xssh = App::Xssh::Config->new();

# Create some extra attributes to define the FG/BG
$xssh->add(["extra","local","foreground"],"red");
$xssh->add(["extra","trusted","background"],"red");

# Create a host entry that references both extra attributes
$xssh->add(["hosts","testhost","extra"],"local,trusted");

# See that the attribute contains the FG and the BG options
my $options = App::Xssh::getTerminalOptions($xssh,"testhost");
ok($options->{foreground} eq "red", "foreground option");
ok($options->{background} eq "red", "background option");

done_testing();
