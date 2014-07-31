Debhelper Plugin to Support Dist::Zilla Packages Natively
=========================================================

dh-dist-zilla provides a debhelper sequence addon named 'dist_zilla'.

The intention is to be able to build directly from a Dist::Zilla based package
without generating the CPAN package manually first.  It is analogous to using
autoreconf to generate the configure script.

The orig.tar.gz file must only contain the dist.ini and source files but not
the generated files like META.yaml, README, etc.
