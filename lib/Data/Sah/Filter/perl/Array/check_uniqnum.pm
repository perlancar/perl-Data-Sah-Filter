package Data::Sah::Filter::perl::Array::check_uniqnum;

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
        summary => 'Check that an array has unique elements, using List::Util\'s uniqnum()',
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
            {value=>[1,2], valid=>1},
            {value=>[1,2,"1.0"], valid=>0},

            {value=>[], filter_args=>{reverse=>1}, valid=>0},
            {value=>[1,2], filter_args=>{reverse=>1}, valid=>0},
            {value=>[1,2,"1.0"], filter_args=>{reverse=>1}, valid=>1},
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
        "do { my \$orig = $dt; \$tmp=".($gen_args->{ci} ? "[map {lc} \@\$orig]":"$dt")."; my \@dupes = List::Util::Uniq::uniqnum( List::Util::Uniq::dupenum(\@\$tmp) ); ",
        ($gen_args->{reverse} ? "\@dupes ? [undef,\$tmp] : [\"Array does not have duplicate number(s)\"]" : "!\@dupes ? [undef,\$tmp] : [\"Array has duplicate number(s): \".join(', ', map { Data::Dmp::dmp(\$_) } \@dupes)]"),
        "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

L<Data::Sah::Filter::perl::Array::uniqnum>.

L<Data::Sah::Filter::perl::Array::check_uniq>,
L<Data::Sah::Filter::perl::Array::check_uniqstr>
