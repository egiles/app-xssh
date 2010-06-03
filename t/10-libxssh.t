use strict;
use warnings;

use Test::More 'no_plan';
use File::Temp;

# Load the script as a module
use_ok("App::Xssh");

# Create an object
my $xssh = App::Xssh->new();
ok($xssh, "Create Object");

# Test (and modify) location of config file
ok($xssh->_configFilename() =~ m/xsshrc/, "reasonable config filename");
my $dir = File::Temp::tempdir( CLEANUP => 1 );
$ENV{HOME} = $dir;

ok($xssh->_configFilename() =~ m/$dir/, "config filename modified");

# try reading and changing the config data
my $data = $xssh->readConfig();
ok($data, "read empty config file");
ok($xssh->addToConfig(["location","key"],"value"), "Modified config data");
ok($xssh->addToConfig(["location","deep","key"],"value2"), "Modified config again");

# Save and reread the config data
ok($xssh->saveConfig(), "Write config out");
my $data2 = $xssh->readConfig();
ok($data2, "read config file again");
ok($data2->{location}->{key} eq "value", "Value retrieved");
ok($data2->{location}->{deep}->{key} eq "value2", "Deep value retrieved");
