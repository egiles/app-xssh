use strict;
use warnings;

use Test::More;
use File::Temp;

use App::Xssh;

# Arrange for a safe place to play
$ENV{HOME} = File::Temp::tempdir( CLEANUP => 1 );

my $xssh = App::Xssh->new();
my $data = {};

# Create a wildcard host option
$xssh->setConfig($data, "hosts/x.*/foreground/red");

# See that a wildcard doesn't change everything
my $o1 = $xssh->getTerminalOptions($data,"abc");
isnt($o1->{foreground}, "red", "options for x.* don't affect abc");

# See that a wildcard does change things that start with 'x'
my $o2 = $xssh->getTerminalOptions($data,"xyz");
is($o2->{foreground}, "red", "options for x.* affect xyz");

done_testing();
