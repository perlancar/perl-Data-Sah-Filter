package Data::Sah::Filter::perl::Float::check_int;

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
        summary => 'Check that a floating point number is integer',
        might_fail => 1,
        args => {
        },
        examples => [
            {value=>1, valid=>1},
            {value=>-1.1, valid=>0},
            {value=>1.1, valid=>0},
        ],
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { my \$tmp=$dt; \$tmp==int(\$tmp) ? [undef, \$tmp] : ['Number must be an integer', \$tmp] }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 DESCRIPTION

This filter checks that number is an integer, i.e. 2.5 fails but 2 succeeds.


=head1 SEE ALSO

Related filters: L<Float::check_has_fraction|Data::Sah::Filter::perl::Float::check_has_fraction>.
