From dist.ini to .deb in one go
===============================

Axel Beckert <abe@debian.org>

#VSLIDE

Some Questions…
---------------

* Who knows debhelper?
* Who packages Perl modules as `.deb`?
* Who packages his own Perl modules as `.deb`?
* Who knows Dist::Zilla?
* Who uses Dist::Zilla for his own Perl Modules?

#HSLIDE

What is Dist::Zilla?
--------------------

Dist::Zilla is "Don't Repeat Yourself" (DRY) for Perl module authors.

* Perl module distributions on CPAN require a bunch of meta data files
  which describe what's in a distribution and its relations,
  e.g. `META.yml`, `META,json`, `Makefile.PL` or `Build.PL`. (And
  debhelper relies on those files, too.)

* In all Perl modules you develop, you always want the same author and
  release tests: Checks for proper style, common errors, POD syntax
  and coverage, etc. (Think Lintian!)

Dist::Zilla generates all these files by gathering information from
your Perl module code plus a single minimal configuration file called
`dist.ini`.

Dist::Zilla's command is `dzil` and it knows subcommands like `git`:

    authordeps: list your distribution's author dependencies
         build: build your dist
         clean: clean up after build, test, or install
         cover: code coverage metrics for your distribution
       install: install your dist
      listdeps: print your distribution's prerequisites
       release: release your dist
           run: run stuff in a dir where your dist is built
         smoke: smoke your dist
          test: test your dist

#HSLIDE

Maintaining Debian Packages of Your Own Dist::Zilla based Perl Modules
----------------------------------------------------------------------

### Typical VCS-Workflow for Building .deb Packages from Your Own Perl Module


1. Build CPAN tar-ball from `master` branch with `dzil build`
2. Switch to the `upstream` branch
3. Import the contents of the tar-ball destined for CPAN into VCS
4. Merge the `upstream` branch into the `debian` branch
5. Update packaging (`debian/changelog`, etc.)
6. Build `.deb` package

### What we want

* Building the `.deb` directly from a VCS checkout
* Skip manual tar-ball generation and reimport
* Don't commit generated files to VCS

#HSLIDE

dh-dist-zilla
-------------

### Obstacles

* `dh-make-perl` (for bootstrapping the Debian packaging) needs CPAN
  meta data.

  * Solution: Run `dh-make-perl` once manually inside the
    `dzil`-generated build directory, copy `debian/` subdirectory back
    into the project root directory.

* debhelper (`dh`) only knows about `Build.PL` and `Makefile.PL`, not
  about `dist.ini`

### Debhelper Sequence Modification

* Generate build directory before debhelper looks for the existing of
  `Build.PL` or `Makefile.PL`.

  * Call `dzil build` before `dh_auto_configure`
  * Ignore generated tar ball

* Build package inside the generated build directory

  * Pass build directory option `-D` to `dh_auto_configure`,
    `dh_auto_build`, `dh_auto_test` and `dh_auto_install`.

* Easy cleanup: Just delete the build directory.

  * Call `dzil clean` before `dh_auto_clean`.

#HSLIDE

How do I use dh-dist-zilla in my Debian package?
------------------------------------------------

It's as simple as this `debian/rules` file:

    #!/usr/bin/make -f
    %:
        dh $@ --with dist-zilla

Additionally, a build-dependency on `dh-dist-zilla` is needed.

### Untypical Workflow

Expected / Traditional:

* VCS → `dzil build` → CPAN tar-ball ∈ Debian Source Package → Debian Binary Package

dh-dist-zilla:

* VCS → `dzil build` → CPAN tar-ball
* VCS = Debian Source Package → Debian Binary Package

#HSLIDE

Example Module/Package
----------------------

[Run::Parts](https://metacpan.org/release/Run-Parts) aka librun-parts-perl

* [librun-parts-perl from Debian Unstable](https://packages.debian.org/unstable/librun-parts-perl),
* [master branch in the Git repository](https://github.com/xtaran/run-parts/tree/dh-dist-zilla)

#HSLIDE

Future / Roadmap
----------------

* `debian/rules` target to create appropriate `.orig.tar.xz` tar balls
* `dzil` subcommand to call `dh-make-perl` in a build directory.

#HSLIDE

Links
-----

### Slides

* http://noone.org/talks/pkg-perl/
* Contact:
  * Axel Beckert <abe@debian.org>
  * Elmar Heeb <elmar@heebs.ch>

### Tools

* dh-dist-zilla: https://github.com/elmar/dh-dist-zilla
  * Available from Debian 8 Jessie onwards:
    https://tracker.debian.org/pkg/dh-dist-zilla
* debhelper: https://anonscm.debian.org/cgit/debhelper/debhelper.git
* Dist::Zilla: http://dzil.org/
* dh-make-perl: https://metacpan.org/release/DhMakePerl
