#!/usr/bin/perl
use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

my $build_dir = 'TODO: foobar...';

insert_before("dh_auto_configure", "dzil build");

add_command_option("dh_auto_build",   "-D $build_dir");
add_command_option("dh_auto_install", "-D $build_dir");
add_command_option("dh_auto_test",    "-D $build_dir");

insert_before("dh_auto_clean", "dzil clean");

1;
