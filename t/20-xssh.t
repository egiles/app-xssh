use strict;
use warnings;

use Test::More 'no_plan';

# Load the script as a module
require_ok("bin/xssh");

# Create a temporary config file, and mess with it
$ENV{HOME} = "TEST";
