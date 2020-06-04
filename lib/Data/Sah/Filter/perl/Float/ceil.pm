package Data::Sah::Filter::perl::Float::ceil;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 1,
        summary => 'Round number to the nearest integer (or "nearest" argument) that is greater than the number',
        args => {
            nearest => {
                schema => 'ufloat*',
            },
        },
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $gen_args = $fargs{args} // {};
    my $nearest = $gen_args->{nearest};
    $nearest += 0 if defined $nearest;

    my $res = {};
    $res->{modules}{POSIX} //= 0;
    $res->{expr_filter} = join(
        "",
        defined($nearest) ? "POSIX::ceil($dt/$nearest)*$nearest" : "POSIX::ceil($dt)",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

Related filters: L<Float::floor|Data::Sah::Filter::perl::Float::floor>,
L<Float::round|Data::Sah::Filter::perl::Float::round>.
