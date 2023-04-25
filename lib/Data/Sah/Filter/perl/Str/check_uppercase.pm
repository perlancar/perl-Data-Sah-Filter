package Data::Sah::Filter::perl::Str::check_uppercase;

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
        summary => 'Check that string is in uppercase',
        might_fail => 1,
        examples => [
            {value=>'FOO', valid=>1},
            {value=>'Foo', valid=>0},
            {value=>'foo', valid=>0},
        ],
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { my \$tmp = $dt; \$tmp eq uc(\$tmp) ? [undef,\$tmp] : [\"String is not in uppercase\"] }",
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
