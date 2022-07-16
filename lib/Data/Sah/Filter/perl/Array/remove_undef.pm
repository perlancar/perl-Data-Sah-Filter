package Data::Sah::Filter::perl::Array::remove_undef;

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
        summary => 'Remove undef elements from an array',
        target_type => 'array',
        args => {
        },
        examples => [
            {value=>[]},
            {value=>["a","b"]},
            {value=>["a","b",undef,"a",undef], filtered_value=>["a","b","a"]},
        ],
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $res = {};
    $res->{expr_filter} = join(
        "",
        "[grep {defined} \@{ $dt }]",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

Related filters: L<Float::check_has_fraction|Data::Sah::Filter::perl::Float::check_has_fraction>.
