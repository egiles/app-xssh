use strict;
use warnings;

use Test::More 'no_plan';
use File::Temp;

use App::Xssh;

# Load the script as a module
require_ok("bin/xssh");

# Create a temporary config file, and mess with it
$ENV{HOME} = File::Temp::tempdir( CLEANUP => 1 );
@ARGV = qw();
ok(!main(), "run script - no params");

@ARGV = qw(--setextraattr extra profile red);
ok(main(), "setextra profile");

@ARGV = qw(--sethostattr testhost foreground red);
ok(main(), "sethost foreground");

@ARGV = qw(--sethostattr DEFAULT background red);
ok(main(), "sethost default background");
@ARGV = qw(--sethostattr testhost extra extra);
ok(main(), "sethost testhost extra");

# Test whether the config options taken hold
my $xssh = App::Xssh->new();
my $options = getTerminalOptions($xssh,"testhost");
ok($options->{foreground} eq "red", "host option found");
ok($options->{background} eq "red", "default option found");
ok($options->{profile} eq "red", "extra option found");

# test if showConfig returns the same information
my $str = showConfig($xssh);
ok($str =~ m/foreground.*red/, "showconfig() contains similar data");

# Just in case all the above isn't really testing anything
ok(!($options->{foreground} eq "blue"), "control test");
