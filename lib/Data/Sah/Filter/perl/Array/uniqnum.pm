package Data::Sah::Filter::perl::Array::uniqnum;

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
        summary => 'Make an array uniq using List::Util\'s uniqnum()',
        target_type => 'array',
        args => {
        },
        examples => [
            {value=>[]},
            {value=>[1, 2]},
            {value=>[1, 2, 1, 1, 3], filtered_value=>[1, 2, 3]},
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
        "[List::Util::uniqnum(\@{ $dt })]",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

L<Data::Sah::Filter::perl::Array::uniqstr>, L<Data::Sah::Filter::perl::Array::uniq>.

L<Data::Sah::Filter::perl::Array::check_uniqnum>.
