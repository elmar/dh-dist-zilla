#!/usr/bin/perl
use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

my $build_root = ".build";
my $build_dir = "$build_root/debian-build";
# Override dzil's looking for $HOME
$ENV{DZIL_GLOBAL_CONFIG_ROOT} = $build_root;

insert_before("dh_auto_configure", "dh_dzil_build");

add_command_options("dh_auto_configure", '-D', $build_dir);
add_command_options("dh_auto_build",     '-D', $build_dir);
add_command_options("dh_auto_install",   '-D', $build_dir);
add_command_options("dh_auto_test",      '-D', $build_dir);

insert_before("dh_auto_clean", "dh_dzil_clean");

# Create an origtar / get-orig-source target
foreach my $target (qw(origtar get-orig-source)) {
    add_command('dh_dist_zilla_origtar', $target);
}

1;
