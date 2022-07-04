package Data::Sah::Filter::js::Str::rtrim;

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
        summary => 'Trim whitespace at the end of string',
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    $res->{expr_filter} = "$dt.trimRight()";

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$
