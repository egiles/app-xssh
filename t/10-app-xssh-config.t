use strict;
use warnings;

use Test::More;
use File::Temp;

use App::Xssh::Config;

# Arrange for a safe place to play
my $dir = File::Temp::tempdir( CLEANUP => 1 );
$ENV{HOME} = $dir;

# Create an object
my $xssh = App::Xssh::Config->new();
ok($xssh, "Create Object");

# Test (and modify) location of config file
ok($xssh->_configFilename() =~ m/xsshrc/, "reasonable config filename");

SKIP: {
  skip("Windows filenames don't play nicely as regular expressions",1) if $dir =~ m/\\/;

  ok($xssh->_configFilename() =~ m/$dir/, "config filename modified");
}

# Given
my $data = $xssh->read();
ok($data, "read empty config file");
$data->{location}->{key} = "value";
ok($xssh->write($data), "Write config out");

# When
my $data2 = $xssh->read();

# Then
ok($data2, "read config file again");
ok($data2->{location}->{key} eq "value", "Value retrieved");

done_testing();
