package Data::Sah::Filter::js::Str::trim;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 1,
        summary => 'Trim whitespace at the beginning and end of string',
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    $res->{expr_filter} = "$dt.trim()";

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$
