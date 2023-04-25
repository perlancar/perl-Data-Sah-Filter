package Data::Sah::Filter::perl::Array::uniqstr;

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
        summary => 'Make an array uniq using List::Util\'s uniqstr() (synonym for uniq)',
        target_type => 'array',
        args => {
        },
        examples => [
            {value=>[]},
            {value=>["a","b"]},
            {value=>["a","b","a","a","c","b"], filtered_value=>["a","b","c"]},
        ],
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $res = {};
    $res->{modules}{'List::Util'} = 1.54;
    $res->{expr_filter} = join(
        "",
        "[List::Util::uniqstr(\@{ $dt })]",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

L<Data::Sah::Filter::perl::Array::uniqnum>, L<Data::Sah::Filter::perl::Array::uniq>

L<Data::Sah::Filter::perl::Array::check_uniqstr>
