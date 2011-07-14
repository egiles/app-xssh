#! /usr/bin/perl

use strict;
use warnings;

use Module::Build;

my $repo = "github.com/egiles/app-xssh";
my $meta1 = "http://$repo";
my $meta2 = {
    type => "git",
    web => $meta1,
    url => "git://$repo.git",
};
my $build = Module::Build->new (
     module_name => 'App::Xssh',
     dist_author => 'Evan Giles <egiles@cpan.org>',
     license  => 'perl',
     requires => {
        'perl'               => '5.6.1',
        'X11::Terminal'      => 0.2,
        'Config::General'    => 2.4,
        'Getopt::Long'       => 2.37,
        'Moose'              => 1.09,
        'Pod::Usage'         => 1.35,
        'UNIVERSAL::require' => 0,
     },
     create_makefile_pl => 'traditional',
     meta_merge     => {
       resources => {
         repository => Module::Build->can("metafile2") ? $meta2 : $meta1,
       }
     },
     add_to_cleanup => [ 'Makefile.PL', 'META.yml' ],
);
$build->create_build_script;
