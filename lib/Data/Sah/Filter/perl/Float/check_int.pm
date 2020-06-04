package Data::Sah::Filter::perl::Float::check_int;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use Data::Dmp;

sub meta {
    +{
        v => 1,
        summary => 'Check that a floating point number is integer',
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
        "do { my \$tmp=$dt; \$tmp==int(\$tmp) ? [undef, \$tmp] : ['Number must be an integer', \$tmp] }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 DESCRIPTION

This filter checks that number is an integer, i.e. 2.5 fails but 2 succeeds.
