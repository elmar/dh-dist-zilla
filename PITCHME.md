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

### What is Dist::Zilla?

* It's "Don't Repeat Yourself" for Perl module authors.

* Perl modules on CPAN require a bunch of meta data files which
  describe its contents and relations, e.g. `META.yml`, `META,json`,
  `Makefile.PL` or `Build.PL`. (debhelper relies on them, too.)

* In all Perl modules you develop, you always want the same author and
  release tests: Checks for proper style, common errors, POD syntax
  and coverage, etc. (Think Lintian!)

#HSLIDE

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

#### Packaging Dist::Zilla based Perl Modules

Typical workflow for building a Perl module .deb:

1. Build CPAN tar-ball from `master` branch with `dzil build`.
2. Switch to the `upstream` branch.
3. Import the CPAN tar-ball's content into Git.
4. Merge `upstream` branch into `debian` branch.
5. Update packaging (`debian/changelog`, etc.)
6. Build `.deb` package

#HSLIDE

### What we want

* Building the `.deb` directly from a VCS checkout
* Skip manual tar-ball generation and reimport
* Don't commit generated files to VCS

#HSLIDE

### dh-dist-zilla's Challenges

* `dh-make-perl` (for bootstrapping the Debian packaging) needs CPAN
  meta data.

  * Solution: Run `dh-make-perl` once manually inside the
    `dzil`-generated build directory, copy `debian/` subdirectory back
    into the project root directory.

* debhelper (`dh`) only knows about `Build.PL` and `Makefile.PL`, not
  about `dist.ini`

#HSLIDE

### Debhelper Sequence Modification

* Generate build directory before debhelper looks for the existing of
  `Build.PL` or `Makefile.PL`: Call `dzil build` before
  `dh_auto_configure` and ignore generated tar-ball.

* Build package inside the generated build directory: Pass build
  directory option `-D` to `dh_auto_{configure,build,test,install}`.

* Easy cleanup: Just delete the build directory by calling `dzil
  clean` before `dh_auto_clean`.

#HSLIDE

### How do I use dh-dist-zilla in my Debian package?

It's as simple as this `debian/rules` file:

    #!/usr/bin/make -f
    %:
        dh $@ --with dist-zilla

Additionally, a build-dependency on `dh-dist-zilla` is needed.

#HSLIDE

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

Additional Helpers
----------------

* Call `dh get-orig-source` to create an appropriate `.orig.tar.xz` tar-ball.

* Call `dh-dzil-refresh` to call `dh-make-perl refresh` inside a build
  directory.

#HSLIDE

### Tools

* dh-dist-zilla: https://github.com/elmar/dh-dist-zilla
  * Available from Debian 8 Jessie onwards:
    https://tracker.debian.org/pkg/dh-dist-zilla
* debhelper: https://anonscm.debian.org/cgit/debhelper/debhelper.git
* Dist::Zilla: http://dzil.org/
* dh-make-perl: https://metacpan.org/release/DhMakePerl

#HSLIDE

### Slides

https://gitpitch.com/elmar/dh-dist-zilla

### Contact

* Axel Beckert <abe@debian.org>
* Elmar Heeb <elmar@heebs.ch>
