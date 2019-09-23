use strict;
use warnings;

use Test::More;
use File::Temp;

use App::Xssh;

# Arrange for a safe place to play
$ENV{HOME} = File::Temp::tempdir( CLEANUP => 1 );

# Given
my $xssh = App::Xssh->new();
my $data = { preexisting => 1};
my $expected = {
    preexisting => 1,
    profile => {
        testprofile => {
            attribute => "red",
        }
    }
};

# When
ok($xssh->setConfig($data, "profile/testprofile/attribute/red"), "store a value in data");

# Then
is_deeply($data, $expected, "correctly added a value to the data structure");



# TODO, test ->showconfig
done_testing();
