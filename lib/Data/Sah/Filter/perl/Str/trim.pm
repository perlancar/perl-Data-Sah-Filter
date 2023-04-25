package Data::Sah::Filter::perl::Str::trim;

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
        summary => 'Trim whitespaces at the beginning and end of string',
        description => <<'_',

Tabs and newlines will also be trimmed.

_
        examples => [
            {value=>'foo'},
            {value=>' foo ', filtered_value=>'foo'},
            {value=>"  \tfoo  \n", filtered_value=>'foo', summary=>"Tabs and newlines will also be trimmed"},
        ],
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { my \$res = $dt; \$res =~ s/\\A\\s+//s; \$res =~ s/\\s+\\z//s; \$res }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

L<Data::Sah::Filter::perl::Str::ltrim>

L<Data::Sah::Filter::perl::Str::rtrim>

L<Data::Sah::Filter::perl::Str::remove_whitespace>
