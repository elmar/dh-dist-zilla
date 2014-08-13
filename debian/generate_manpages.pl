#!/usr/bin/perl

# Helper script to guess which files pod2man should use as input based
# on the man pages listed in debian/manpages. Goal: Only specify them
# once there, i.e. DRY.

use strict;
use warnings;
use autodie;

my $list_of_manpages = 'debian/manpages';

my $version = `dpkg-parsechangelog -SVersion`; chomp($version);
my @pod2man = (qw(pod2man -c dh-dist-zilla -r), "dh-dist-zilla v$version");

open(my $dmp, '<', $list_of_manpages);
while (my $line = <$dmp>) {
    chomp($line);

    # Expect man page section as file suffix
    my ($name, $section) = split(/\./, $line);

    # Expand potential wildcards and check for existence
    my @names = get_names($name);

    # If there was no initial match, try appending ".pod"
    unless (@names) {
        my $checkname = "$name.pod";
        @names = get_names($checkname);
    }

    # Assert non-empty list
    die "No file found for '$line'" unless (@names);

    foreach my $name (@names) {
        # Remove .pod suffix from final name again
        my $man_page_name = $name;
        $man_page_name =~ s/\.pod$//;

        # Finally call pod2man
        system(@pod2man, "--section=$section",
               $name, "$man_page_name.$section");
    }
}
close($dmp);

sub get_names {
    return grep { -e } map { glob } @_;
}
