package Data::Sah::Filter::perl::Str::remove_whitespace;

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
        summary => 'Remove whitespaces from string',
        description => <<'_',

Tabs and newlines will also be removed.

_
        args => {
        },
        examples => [
            {value=>"foo"},
            {value=>"foo  bar ", filtered_value=>"foobar"},
            {value=>"  foo \t bar \n ", filtered_value=>"foobar", summary=>"Tabs and newlines will also be removed"},
        ],
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    #my $gen_args = $fargs{args} // {};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { my \$tmp = $dt; \$tmp =~ s/\\s+//gs; \$tmp }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

L<Data::Sah::Filter::perl::Str::trim>

L<Data::Sah::Filter::perl::Str::ltrim>

L<Data::Sah::Filter::perl::Str::rtrim>

Other C<Data::Sah::Filter::perl::Str::remove_*> modules.
