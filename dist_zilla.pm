#!/usr/bin/perl
use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;
use Config::INI::Reader;

my $dist_ini  = Config::INI::Reader->read_file('dist.ini');
my $name      = $dist_ini->{'_'}{name};
my $version   = $dist_ini->{'_'}{version};
my $build_dir = "$name-$version";

insert_before("dh_auto_configure", "dh_dzil_build");

add_command_options("dh_auto_configure", '-D', $build_dir);
add_command_options("dh_auto_build",     '-D', $build_dir);
add_command_options("dh_auto_install",   '-D', $build_dir);
add_command_options("dh_auto_test",      '-D', $build_dir);

insert_before("dh_auto_clean", "dh_dzil_clean");

1;
