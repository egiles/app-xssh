use strict;
use warnings;

use Test::More 'no_plan';
use File::Temp;

use App::Xssh;

# Load the script as a module
require_ok("bin/xssh");

# Create a temporary config file, and mess with it
$ENV{HOME} = File::Temp::tempdir( CLEANUP => 1 );
ok(system("bin/xssh")==0, "run script no params");
ok(system("bin/xssh --setextraattr extra profile red")==0, "setextra profile");
ok(system("bin/xssh --sethostattr testhost foreground red")==0, "sethost foreground");
ok(system("bin/xssh --sethostattr DEFAULT background red")==0, "sethost default background");
ok(system("bin/xssh --sethostattr testhost extra extra")==0, "sethost foreground");

# Test whether the config options taken hold
my $xssh = App::Xssh->new();
my $options = getTerminalOptions($xssh,"testhost");
ok($options->{foreground} eq "red", "host option found");
ok($options->{background} eq "red", "default option found");
ok($options->{profile} eq "red", "extra option found");

# test if showConfig returns the same information
my $str = showConfig($xssh);
ok($str =~ m/testhost.*foreground.*red/, "showconfig() contains similar data");

# Just in case all the above isn't really testing anything
ok(!($options->{foreground} eq "blue"), "control test");
