use 5.6.0;

use strict;
use ExtUtils::MakeMaker;

my $params = {
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
};

if ( $ExtUtils::MakeMaker::VERSION gt "6.46" ) {
  $params->{META_MERGE} = { resources => { repository  => 'git://github.com/egiles/App-xssh.git' } };
}

WriteMakefile(%$params);
