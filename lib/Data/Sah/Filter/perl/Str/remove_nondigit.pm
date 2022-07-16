package Data::Sah::Filter::perl::Str::remove_nondigit;

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
        summary => 'Remove non-digit characters',
        examples => [
            {value=>"5551234567"},
            {value=>"555-123-4567", filtered_value=>"5551234567"},
            {value=>"(555) 123-4567", filtered_value=>"5551234567"},
        ],
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { ", (
            "my \$tmp = $dt; ",
            "\$tmp =~ s/\\D+//g; ",
            "\$tmp ",
        ), "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO
