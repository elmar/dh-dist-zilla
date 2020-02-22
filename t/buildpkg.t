#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Test::More;
use Test::Script::Run qw(:all);

my $pkgname = 'libexample-dz-perl';
my $pkgver  = '1.0';
my $debrev  = '1';
my @dbpparm = (qw(-uc -us), $ENV{AUTOPKGTEST_TMP} ? () : qw(-d));
my $path = $ENV{AUTOPKGTEST_TMP} ? '/usr/bin' : '.';

chdir("t/$pkgname");
$ENV{HOME} = '.';

unless ($ENV{AUTOPKGTEST_TMP}) {
    $ENV{PERL5LIB} = '../../lib' . ($ENV{PERL5LIB} ? ":$ENV{PERL5LIB}" : '');
    $ENV{PATH} = '../..:/usr/bin:/bin';
    @Test::Script::Run::BIN_DIRS = qw(../.. /usr/bin /bin);
}

# dh_dzil_clean
run_ok("$path/dh_dzil_clean", [],
       "dh_dzil_clean runs without error");

# dh_dist_zilla_origtar
run_ok("$path/dh_dist_zilla_origtar", [],
       "dh_dist_zilla_origtar runs without error");
is(last_script_stdout(), '',
   'dh_dist_zilla_origtar runs without output on STDOUT');
is(last_script_stderr(), '',
   'dh_dist_zilla_origtar runs without output on STDERR');
ok(-e "../${pkgname}_${pkgver}.orig.tar.xz" && -f _ && -s _,
   "orig.tar.xz has been generated");

# Actual package build
run_ok('/usr/bin/dpkg-buildpackage', \@dbpparm,
       'dpkg-buildpackage runs without error');
foreach my $line ('dh_dzil_clean',
                  'dh_dzil_build',
                  '[DZ] beginning to build Example-DZ',
                  '[DZ] built in .build/debian-build',
                  'dh_auto_configure -D .build/debian-build',
                  'Writing Makefile for Example::DZ',
                  'dh_auto_build -D .build/debian-build') {
    like(last_script_stdout(), qr/\Q$line/, "build log contains '$line'");
}

#say last_script_stderr();
#say last_script_stdout();

foreach my $artifact (qw(
                      .debian.tar.xz
                      .dsc
                      _all.deb
                      _*.buildinfo
                      _*.changes
                      )) {
    my $file = "${pkgname}_${pkgver}-${debrev}${artifact}";
    #my $path = glob("../$file");
    my $path = `ls -1 ../$file`; chomp($path);
    ok(-e $path, "$file = $path has been generated");
    ok(-f $path, "$file = $path is a file");
    ok(-s $path, "$file = $path is not empty");
}

# Cleanup
run_ok('/usr/bin/dpkg-buildpackage', [@dbpparm, qw(-T clean)],
       'dpkg-buildpackage clean runs without error');
unlink(glob("../${pkgname}_${pkgver}*"));

done_testing();
