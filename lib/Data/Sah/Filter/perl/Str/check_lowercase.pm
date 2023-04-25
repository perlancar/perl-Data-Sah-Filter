package Data::Sah::Filter::perl::Str::check_lowercase;

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
        summary => 'Check that string is in lowercase',
        might_fail => 1,
        examples => [
            {value=>'foo', valid=>1},
            {value=>'Foo', valid=>0},
            {value=>'FOO', valid=>0},
        ],
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { my \$tmp = $dt; \$tmp eq lc(\$tmp) ? [undef,\$tmp] : [\"String is not in lowercase\"] }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

=head2 Related filters

L<check_uppercase|Data::Sah::Filter::perl::Str::check_uppercase>.

L<lowercase|Data::Sah::Filter::perl::Str::lowercase> to convert string to
lowercase.
