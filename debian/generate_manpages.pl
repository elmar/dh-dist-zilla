#!/usr/bin/perl

use strict;
use warnings;
use autodie;

my $list_of_manpages = 'debian/manpages';

my $version = `dpkg-parsechangelog -SVersion`; chomp($version);
my @pod2man = (qw(pod2man -c dh-dist-zilla -r), "dh-dist-zilla v$version");

open(my $dmp, '<', $list_of_manpages);
while (my $line = <$dmp>) {
    chomp($line);
    my ($name, $section) = split(/\./, $line);

    unless (-e $name) {
        $name .= '.pod';
    }

    system(@pod2man, "--section=$section", $name, $line);
}
