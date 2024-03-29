package Data::Sah::Filter::perl::Array::check_uniq;

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
        summary => 'Check that an array has unique elements, using List::Util\'s uniq()',
        target_type => 'array',
        might_fail => 1,
        args => {
            reverse => {
                summary => 'If set to true, then will *fail* when array is unique',
                schema => 'bool*',
            },
        },
        examples => [
            {value=>[], valid=>1},
            {value=>["a","b"], valid=>1},
            {value=>["a","b","a"], valid=>0},
            {value=>["a","b","A"], valid=>1, summary=>'Use Array::check_uniqstr filter for case insensitivity option'},

            {value=>[], filter_args=>{reverse=>1}, valid=>0},
            {value=>["a","b"], filter_args=>{reverse=>1}, valid=>0},
            {value=>["a","b","a"], filter_args=>{reverse=>1}, valid=>1},
            {value=>["a","b","A"], filter_args=>{reverse=>1}, valid=>0, summary=>'Use Array::check_uniqstr filter for case insensitivity option'},
        ],
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $gen_args = $fargs{args} // {};
    my $res = {};
    $res->{modules}{'List::Util::Uniq'} = "0.005";
    $res->{modules}{'Data::Dmp'} = "0.242";
    $res->{expr_filter} = join(
        "",
        "do { my \$tmp=$dt; my \@dupes = List::Util::Uniq::uniq( List::Util::Uniq::dupe(\@\$tmp) ); ",
        ($gen_args->{reverse} ? "\@dupes ? [undef,\$tmp] : [\"Array does not have duplicate element(s)\"]" : "!\@dupes ? [undef,\$tmp] : [\"Array has duplicate element(s): \".join(', ', map { Data::Dmp::dmp(\$_) } \@dupes)]"),
        "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 FAQ

=head2 How to check that array contains a duplicate?

Use the C<reverse> argument and set it to 1.


=head1 SEE ALSO

L<Data::Sah::Filter::perl::Array::uniqnum>.

L<Data::Sah::Filter::perl::Array::check_uniq>,
L<Data::Sah::Filter::perl::Array::check_uniqstr>
