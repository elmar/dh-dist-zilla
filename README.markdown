Debhelper Plugin to Support Dist::Zilla Packages Natively
=========================================================

The Debian package dh-dist-zilla provides a
[debhelper](http://joeyh.name/code/debhelper/) sequence addon named
'dist_zilla'.

The intention is to be able to build Debian packages (`.deb` files) directly
from a [Dist::Zilla](http://dzil.org/) based Perl package without
generating the CPAN package manually first.  It is analogous to using
`autoreconf` to generate the `configure` script.

The `orig.tar.gz` file must only contain the `dist.ini` and source
files but not the generated files like `META.yaml`, `README`, etc.

See [dh-dist-zilla.pod](dh-dist-zilla.pod) for details on how to
use it.
