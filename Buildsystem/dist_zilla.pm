#!/usr/bin/perl

package Debian::Debhelper::Buildsystem::dist_zilla;

use warnings;
use strict;
use base 'Debian::Debhelper::Buildsystem';
use Config::INI::Reader;
use Debian::Debhelper::Buildsystem::perl_build;
use Debian::Debhelper::Buildsystem::perl_makemaker;
use Debian::Debhelper::Dh_Lib qw(basename);

use Debian::Debhelper::Dh_Buildsystems;
push(@Debian::Debhelper::Dh_Buildsystems::BUILDSYSTEMS, 'dist_zilla');

sub DESCRIPTION {
        "Perl Dist::Zilla (dist.ini)"
}

sub check_auto_buildable {
    my ($this, $step) = $@;
    if ($step eq 'configure' or $step eq 'clean') {
        # Here Dist::Zilla comes into place
        return -e $this->get_sourcepath("dist.ini");
    } else {
        return (Debian::Debhelper::Buildsystem::perl_build->new->check_auto_buildable(@_) or
                Debian::Debhelper::Buildsystem::perl_makemaker->new->check_auto_buildable(@_));
    }
}

sub new {
        my $class = shift;

        my $dist_ini  = Config::INI::Reader->read_file('dist.ini');
        my $name      = $dist_ini->{'_'}{name};
        my $version   = $dist_ini->{'_'}{version};
        my $build_dir = "$name-$version";

        my $step = basename($0);
        $step =~ s/^dh_auto_//;

        my $this = $class->SUPER::new(
            @_,
            sourcedir => ($step eq 'clean' or $step eq 'configure') ? '.' : $build_dir,
            builddir  => ($step eq 'configure') ? $build_dir : undef,
            );
        #$this->enforce_in_source_building();

        return $this;
}

sub _makemaker {
    my $this = shift;
    my @params = @_ ? @_ : (sourcedir => $this->get_sourcedir());
    return Debian::Debhelper::Buildsystem::perl_makemaker->new(@params);
}
sub _build {
    my $this = shift;
    my @params = @_ ? @_ : (sourcedir => $this->get_sourcedir());
    return Debian::Debhelper::Buildsystem::perl_build->new(@params);
}

sub configure {
        my $this=shift;
        $this->doit_in_sourcedir("dzil", "build", @_);
        my $mb = $this->_build(sourcedir => $this->get_builddir());
        my $mm = $this->_makemaker(sourcedir => $this->get_builddir());
        if ($mb->check_auto_buildable('configure')) {
            return $mb->configure(@_);
        } elsif ($mm->check_auto_buildable('configure')) {
            return $mm->configure(@_);
        }
}

sub build {
        my $this=shift;
        my $mb = $this->_build();
        my $mm = $this->_makemaker();
        if ($mb->check_auto_buildable('build')) {
            return $mb->build(@_);
        } elsif ($mm->check_auto_buildable('build')) {
            return $mm->build(@_);
        }
}

sub install {
        my $this=shift;
        my $mb = $this->_build();
        my $mm = $this->_makemaker();
        if ($mb->check_auto_buildable('install')) {
            return $mb->install(@_);
        } elsif ($mm->check_auto_buildable('install')) {
            return $mm->install(@_);
        }
}

sub test {
        my $this=shift;
        my $mb = $this->_build();
        my $mm = $this->_makemaker();
        if ($mb->check_auto_buildable('test')) {
            return $mb->test(@_);
        } elsif ($mm->check_auto_buildable('test')) {
            return $mm->test(@_);
        }
}

sub clean {
        my $this=shift;
        $this->doit_in_sourcedir("dzil", "clean", @_);
}


1;
