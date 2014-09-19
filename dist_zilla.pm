#!/usr/bin/perl
use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

my $build_dir = ".build/debian-build";

insert_before("dh_auto_configure", "dh_dzil_build");

add_command_options("dh_auto_configure", '-D', $build_dir);
add_command_options("dh_auto_build",     '-D', $build_dir);
add_command_options("dh_auto_install",   '-D', $build_dir);
add_command_options("dh_auto_test",      '-D', $build_dir);

insert_before("dh_auto_clean", "dh_dzil_clean");

1;
