use strict;
use warnings;

use Test::More;
use File::Temp;

use App::Xssh;
use App::Xssh::Config;

# Arrange for a safe place to play
$ENV{HOME} = File::Temp::tempdir( CLEANUP => 1 );

my $xssh = App::Xssh::Config->new();

# Create a wildcard host option
$xssh->add(["hosts","x.*","foreground"],"red");

# See that a wildcard doesn't change everything
my $o1 = App::Xssh::getTerminalOptions($xssh,"abc");
isnt($o1->{foreground}, "red", "options for x.* don't affect abc");

# See that a wildcard does change things that start with 'x'
my $o2 = App::Xssh::getTerminalOptions($xssh,"xyz");
is($o2->{foreground}, "red", "options for x.* affect xyz");

done_testing();
