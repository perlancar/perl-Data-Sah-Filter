package Data::Sah::Filter::perl::Str::remove_non_latin_alphanum;

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
        summary => 'Remove characters that are not [A-Za-z0-9]',
        examples => [
            {value=>"aBc123"},
            {value=>"aBc 123..4_56", filtered_value=>"aBc123456"},
        ],
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { ", (
            "my \$tmp = $dt; ",
            "\$tmp =~ s/[^A-Za-z0-9]+//g; ",
            "\$tmp ",
        ), "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

Other C<Data::Sah::Filter::perl::Str::remove_*> modules.

L<Data::Sah::Filter::perl::Str::underscore_non_latin_alphanum>

L<Data::Sah::Filter::perl::Str::underscore_non_latin_alphanums>
