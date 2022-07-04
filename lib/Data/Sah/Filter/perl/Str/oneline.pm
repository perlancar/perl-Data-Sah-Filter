package Data::Sah::Filter::perl::Str::oneline;

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
        summary => 'Replace newlines with spaces',
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { my \$res = $dt; \$res =~ s/\\R/ /g; \$res }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 DESCRIPTION
