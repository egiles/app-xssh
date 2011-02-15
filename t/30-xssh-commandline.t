use strict;
use warnings;

use Test::More;
use File::Temp;

eval "use Test::Command";
plan skip_all => "Test::Command required for testing command line" if $@;

# Load the module
use_ok("App::Xssh");

# Arrange for a safe place to play
$ENV{HOME} = File::Temp::tempdir( CLEANUP => 1 );

exit_isnt_num("bin/xssh --crazy",0);

exit_isnt_num("bin/xssh --setprofileopt testprofile attribute",0);
exit_is_num("bin/xssh --setprofileopt testprofile attribute red",0);

exit_isnt_num("bin/xssh --sethostopt testhost foreground",0);
exit_is_num("bin/xssh --sethostopt testhost foreground red",0);

done_testing();
