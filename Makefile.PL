use 5.6.0;

use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'App::Xssh',
    ABSTRACT      => 'Interface to launching X terminal windows',
    AUTHOR        => 'Evan Giles <egiles@cpan.org>',
    LICENSE       => 'perl',
    PREREQ_PM     => { 'X11::Terminal' => '0.2',
                       'Config::General' => '2.40',
                       'Getopt::Long' => '2.37',
                       'Pod::Usage' => '1.35',
                     },
    VERSION_FROM  => 'lib/App/Xssh.pm',
    EXE_FILES     => [ 'bin/xssh' ],
    clean         => { FILES=>'*stamp App-Xssh* debian/files debian/libapp-xssh-perl*' },
);
