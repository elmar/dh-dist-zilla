package Example::DZ;

# ABSTRACT: Dummy test package for dh-dist-zilla

use strict;
use warnings;
use 5.010;

=encoding utf8

=head1 SYNOPSIS

Dummy test package for dh-dist-zilla

=cut

sub new {
    my $self = {};
    bless($self, shift);
    return $self;
}

42; # End of Example::DZ
