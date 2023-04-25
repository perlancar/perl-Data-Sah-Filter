package Data::Sah::Filter::perl::Str::ltrim;

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
        summary => 'Trim whitespaces at the beginning of string',
        description => <<'_',

Leading tabs and newlines will also be trimmed.

_
        examples => [
            {value=>'foo'},
            {value=>' foo ', filtered_value=>'foo '},
            {value=>"  \t  \nfoo ", filtered_value=>'foo ', summary=>"Leading tabs and newlines will also be trimmed"},
        ],
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { my \$res = $dt; \$res =~ s/\\A\\s+//s; \$res }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

L<Data::Sah::Filter::perl::Str::trim>

L<Data::Sah::Filter::perl::Str::rtrim>

L<Data::Sah::Filter::perl::Str::remove_whitespace>
