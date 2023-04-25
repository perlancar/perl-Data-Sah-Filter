package Data::Sah::Filter::perl::Str::check_oneline;

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
        summary => 'Check that string does not contain more than one line',
        description => <<'_',

You can also use the <pm:Sah> clause C<match> to achieve the same:

    # a schema, using 'match' clause and regex to match string that does not contain a newline
    ["str", {"match" => qr/\A(?!.*\R).*\z/}]

    # a schema, using reversed 'match' clause and regex to match newline
    ["str", {"!match" => '\\R'}]

_
        might_fail => 1,
        examples => [
            {value=>'', valid=>1},
            {value=>"foo", valid=>1},
            {value=>("foo bar\tbaz" x 10), valid=>1, summary=>"Long line, spaces and tabs are okay as long as it does not contain newline"},
            {value=>"foo\n", valid=>0, summary=>"Containing newline at the end counts as having more than oneline; use the Str::rtrim or Str::rtrim_newline if you want to remove trailing newline"},
            {value=>"foo\nbar", valid=>0},
            {value=>"\n", valid=>0},
        ],
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { my \$tmp = $dt; \$tmp !~ /\\R/ ? [undef,\$tmp] : [\"String contains newline\"] }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

=head2 Related filters

L<check_lowercase|Data::Sah::Filter::perl::Str::check_lowercase>.

L<uppercase|Data::Sah::Filter::perl::Str::uppercase> to convert string to
uppercase.
