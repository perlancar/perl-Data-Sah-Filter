package Data::Sah::Filter::perl::Str::rtrim;

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
        summary => 'Trim whitespaces at the end of string',
        description => <<'_',

Trailing tabs and newlines will also be trimmed.

_
        examples => [
            {value=>'foo'},
            {value=>' foo ', filtered_value=>' foo'},
            {value=>" foo  \t  \n", filtered_value=>' foo', summary=>"Trailing tabs and newlines will also be trimmed"},
        ],
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { my \$res = $dt; \$res =~ s/\\s+\\z//s; \$res }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

L<Data::Sah::Filter::perl::Str::trim>

L<Data::Sah::Filter::perl::Str::ltrim>

L<Data::Sah::Filter::perl::Str::remove_whitespace>
