package Data::Sah::Filter::perl::Float::check_has_fraction;

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
        summary => 'Check that a floating point number has non-zero fraction',
        description => <<'_',

This is the opposite of the `Float::check_int` filter.

_
        might_fail => 1,
        args => {
        },
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { my \$tmp=$dt; \$tmp!=int(\$tmp) ? [undef, \$tmp] : ['Number must have fraction', \$tmp] }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 DESCRIPTION


=head1 SEE ALSO

Related filters: L<Float::check_int|Data::Sah::Filter::perl::Float::check_int>.
