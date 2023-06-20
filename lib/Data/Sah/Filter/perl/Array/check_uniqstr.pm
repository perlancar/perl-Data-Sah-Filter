package Data::Sah::Filter::perl::Array::check_uniqstr;

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
        summary => 'Check that an array has unique elements, using List::Util\'s uniqstr() (synonym for uniq())',
        target_type => 'array',
        might_fail => 1,
        args => {
            reverse => {
                summary => 'If set to true, then will *fail* when array is unique',
                schema => 'bool*',
            },
            ci => {
                summary => 'Ignore case',
                schema => 'bool*',
            },
        },
        examples => [
            {value=>[], valid=>1},
            {value=>["a","b"], valid=>1},
            {value=>["a","b","a"], valid=>0},
            {value=>["a","b","A"], valid=>1},
            {value=>["a","b","A"], filter_args=>{ci=>1}, valid=>0},

            {value=>[], filter_args=>{reverse=>1}, valid=>0},
            {value=>["a","b"], filter_args=>{reverse=>1}, valid=>0},
            {value=>["a","b","a"], filter_args=>{reverse=>1}, valid=>1},
            {value=>["a","b","A"], filter_args=>{reverse=>1}, valid=>0},
            {value=>["a","b","A"], filter_args=>{reverse=>1, ci=>1}, valid=>1},
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
        "do { my \$orig = $dt; \$tmp=".($gen_args->{ci} ? "[map {lc} \@\$orig]":"$dt")."; my \@dupes = List::Util::Uniq::uniqstr( List::Util::Uniq::dupestr(\@\$tmp) ); ",
        ($gen_args->{reverse} ? "\@dupes ? [undef,\$orig] : [\"Array does not have duplicate string(s)\"]" : "!\@dupes ? [undef,\$orig] : [\"Array has duplicate string(s): \".join(', ', map { Data::Dmp::dmp(\$_) } \@dupes)]"),
         "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

L<Data::Sah::Filter::perl::Array::uniqstr>.

L<Data::Sah::Filter::perl::Array::check_uniq>,
L<Data::Sah::Filter::perl::Array::check_uniqnum>
