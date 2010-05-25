require 5.6.0;

use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'App::xssh',
    'ABSTRACT'      => 'interface to launching X terminal windows',
    'AUTHOR'        => 'Evan Giles <egiles@cpan.org>',
    'LICENSE'       => 'perl',
    'PREREQ_PM'     => { 'X11::Terminal' => '0.1',
                         'Config::General' => '2.40',
                         'Getopt::Long' => '2.37',
                         'Pod::Usage' => '1.35',
                    },
    'VERSION_FROM'  => 'bin/xssh',
    'EXE_FILES'     => [ 'bin/xssh' ],
    'dist'          => { COMPRESS=>'gzip', SUFFIX=>'gz' },
);
