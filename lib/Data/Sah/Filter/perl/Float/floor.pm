package Data::Sah::Filter::perl::Float::floor;

use 5.010001;
use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

sub meta {
    +{
        v => 1,
        summary => 'Round number to the nearest integer (or "nearest" argument) that is less than the number',
        args => {
            nearest => {
                schema => 'ufloat*',
            },
        },
        examples => [
            {value=>1, filtered_value=>1},
            {value=>-1.1, filtered_value=>-2},
            {value=>1.1, filtered_value=>1},
            {value=>1.6, filter_args=>{nearest=>0.5}, filtered_value=>1.5},
        ],
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
        defined($nearest) ? "POSIX::floor($dt/$nearest)*$nearest" : "POSIX::floor($dt)",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

Related filters: L<Float::ceil|Data::Sah::Filter::perl::Float::ceil>,
L<Float::round|Data::Sah::Filter::perl::Float::round>.
