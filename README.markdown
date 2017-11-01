Debhelper Plugin to Support Dist::Zilla Packages Natively
=========================================================

The Debian package dh-dist-zilla provides a
[debhelper](https://joeyh.name/code/debhelper/) sequence addon named
'dist_zilla'.

The intention is to be able to build Debian packages (`.deb` files)
directly from a [`Dist::Zilla`](http://dzil.org/) based Perl package
without generating the CPAN package manually first.  It is analogous
to using `autoreconf` to generate the `configure` script.

The `orig.tar.gz` file must only contain the `dist.ini` and source
files but not the generated files like `META.yml`, `README`, etc.

See [dh-dist-zilla.pod](dh-dist-zilla.pod) for details on how to use
it or have a look at dh-dist-zilla's
[GitPitch slideshow](https://gitpitch.com/elmar/dh-dist-zilla).

Background
----------

The Perl community and [CPAN](http://www.cpan.org/) in particular use
a few tools to build Perl packages.  The classic approach is to
write a `Makefile.PL` script using
[`ExtUtils::MakeMaker`](http://perldoc.perl.org/ExtUtils/MakeMaker.html).
The alternative variant uses
[`Build.PL`](http://perldoc.perl.org/Module/Build.html)
written with `Module::Build`.  Both are part of the Perl core, but
`Module::Build` has been deprecated recently and will be removed from
the core with the next Perl release.  For the distribution on CPAN a
few more files like LICENSE, MANIFEST, META.yml, and README need to be
added.

There is some tedium in writing all these files and there is no
surprise to find code generators for them.
[`Module::Starter`](https://metacpan.org/pod/Module::Starter)
is such a code generator that is very commonly used.  It helps a lot
getting started.  However, maintenance still needs to make sure that
information like version numbers or documentation is kept consistent.

Enter [`Dist::Zilla`](http://dzil.org/).  The basic promise of
`Dist::Zilla`, also known by its command line program `dzil`, is to
keep all relevant information exactly once in a place where the
particular piece of information fits best.  Given the appropriate
plugin `dzil build` will generate all the files needed for CPAN.
E.g., the author, version, and license type is stored in exactly one place
(typically in a file called`dist.ini`and only there) and then used to add it in
the appropriate places.  Likewise `MANIFEST` and other boilerplate files are
created or updated by each invocation of `dzil build`.

Technically, `dzil` can be used like `module-starter` or any other
code generator.  On the other hand its full potential is only taken
advantage of if the generated files are never touched and only
`dist.ini` and the other files proper to the package are editied.
This makes development more consistent and eliminates whole classes
of bugs.

With `dzil` you also avoid having to commit to either
`ExtUtils::MakeMaker` or `Module::Build`.  You can switch back and
forth by replacing a `Dist::Zilla` plugin specification.  If another
successor to MakeMaker should appear and be successful you will most
certainly be able to use a `Dist::Zilla` plugin to make use of it.  This, of
course, only applies if you are just using features supported by both or all
build mechanisms you want to switch between them.

Debian Packaging of Perl Code
-----------------------------

When packaging Perl code Debian relies heavily on CPAN or at least
on the package contents of a package conforming to the CPAN standard.
[Debhelper](https://joeyh.name/code/debhelper/)
can rely on either `Makefile.PL` or `Build.PL` to be present and
conform to the common standard procedures accepting all their well
defined options.

If the package is built and maintained using `Dist::Zilla` it would
be advantageous to build from the original source files like
`dist.ini` rather than base it on derived files like `Build.PL`.  The
most prominent benefits are avoiding inconsistencies and
incorporating all improvements and bug fixes that went into
`Dist::Zilla`.

Another concern is that generated files should not enter a VCS like
[Git](https://git-scm.com/).  Not only are generated files redundant
and can be recreated whenever needed, but they can easily become
inconsistent and therefore be confusing and lead to subtle bugs.

The purpose of `dh-dist-zilla` is to enable debhelper to build a
Debian package for Perl code directly from `dist.ini` and the
original source code.  In particular, it allows to build a Debian
package directly from a VCS checkout.

Further Reading
---------------

* [The official Dist::Zilla Tutorials](http://dzil.org/tutorial/start.html)
  by Ricardo Signes and others

* [The ExtUtils::MakeMaker::FAQ](http://perldoc.perl.org/ExtUtils/MakeMaker/FAQ.html) where among other things they point out that MakeMaker deserves to be replaced by something better but, unfortunately, `Module::Build` is not quite that replacement.

* [Module::Build](http://www.perl.com/pub/2003/02/12/module1.html) as a
  replacement for `ExtUtils::MakeMaker` by Dave Rolsky (note: this is dated, being
  from 2003, but shows the motivation of replacing MakeMaker)

* [More Code, Less Cruft: Managing Distributions with Dist::Zilla](http://www.perl.com/pub/2010/03/more-code-less-cruft-managing-distributions-with-distzilla.html)
  by Ricardo Signes (from 2010, outdated in some details but still nicely showing
  the goals of the tool)

See Also
--------

* `Dist::Zilla::App::Command::authordebs`
  [on GitHub](https://github.com/dod38fr/dist-zilla-app-command-authordebs)
  [on CPAN](https://metacpan.org/pod/Dist::Zilla::App::Command::authordebs)

Version Numbers
---------------

We try to conform to [Semantic Versioning](http://semver.org/) with
the only exception that we omit trailing zeros, i.e. version 1 is
equivalent to version 1.0.0.

Which Distribution Ships Which Version?
---------------------------------------

[![Packaging status](https://repology.org/badge/vertical-allrepos/dh-dist-zilla.svg)](https://repology.org/metapackage/dh-dist-zilla)
