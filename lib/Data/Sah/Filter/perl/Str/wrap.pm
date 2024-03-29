package Data::Sah::Filter::perl::Str::wrap;

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
        summary => 'Wrap text',
        args => {
            columns => {
                schema => 'uint*',
                default => 72,
            },
        },
        examples => [
            {value=>"foo"},
            {value=>"foo foo foo foo"},
            {value=>"foo foo foo foo", filter_args=>{columns=>4}, filtered_value=>"foo\nfoo\nfoo\nfoo"},
        ],
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $gen_args = $fargs{args} // {};

    my $res = {};
    $res->{modules}{"Text::Wrap"} //= 0;

    $res->{expr_filter} = join(
        "",
        "do { ", (
            "local \$Text::Wrap::columns = ", (($gen_args->{columns} // 72)+0), "; ",
            "Text::Wrap::wrap('', '', $dt); ",
        ), "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 DESCRIPTION


=head1 SEE ALSO

L<Data::Sah::Filter::perl::Str::oneline>
