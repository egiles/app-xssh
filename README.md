[![Build Status](https://travis-ci.com/egiles/app-xssh.svg?branch=master)](https://travis-ci.com/egiles/app-xssh)

# Description

    bin/xssh
      Program to allow you to ssh to a remote host inside a new
      X Terminal window (like XTerm).  

    App::Xssh
      Library to support the xssh program

    App::Xssh::Config
      Library to support reading and writing to the config file


# Dependencies

    App::Xssh requires at least perl 5.6.0 and these other modules:

      Config::General
      Moose;
      X11::Terminal


# Installation

    Standard process for building & installing modules:

      perl Build.PL
      ./Build
      ./Build test
      ./Build install


# Copyright and licence

    Copyright 2010-2020 Evan Giles <egiles@cpan.org>.

    This program is free software; you can redistribute it
    and/or modify it under the same terms as Perl itself.
