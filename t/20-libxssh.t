use strict;
use warnings;

use Test::More;
use File::Temp;

# Load the script as a module
use_ok("App::Xssh");

# Create a temporary config file, and mess with it
$ENV{HOME} = File::Temp::tempdir( CLEANUP => 1 );
@ARGV = qw();
ok(!App::Xssh::main(), "run script - no params");

@ARGV = qw(--setextraattr extra profile red);
ok(App::Xssh::main(), "setextra profile");

@ARGV = qw(--sethostattr testhost foreground red);
ok(App::Xssh::main(), "sethost foreground");

@ARGV = qw(--sethostattr DEFAULT background red);
ok(App::Xssh::main(), "sethost default background");
@ARGV = qw(--sethostattr testhost extra extra);
ok(App::Xssh::main(), "sethost testhost extra");

# Test whether the config options taken hold
use App::Xssh::Config;
my $config = App::Xssh::Config->new();
my $options = App::Xssh::getTerminalOptions($config,"testhost");
ok($options->{foreground} eq "red", "host option found");
ok($options->{background} eq "red", "default option found");
ok($options->{profile} eq "red", "extra option found");

# test if showConfig returns the same information
my $str = $config->show($config);
ok($str =~ m/foreground.*red/, "showconfig() contains similar data");

# Just in case all the above isn't really testing anything
ok(!($options->{foreground} eq "blue"), "control test");

done_testing();
