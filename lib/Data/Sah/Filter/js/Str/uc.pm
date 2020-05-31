package Data::Sah::Filter::js::Str::uc;

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
        summary => 'Convert string to uppercase',
        target_type => 'str',
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    $res->{expr_filter} = "$dt.toUpperCase()";

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

Related filters: L<lc|Data::Sah::Filter::js::Str::lc>.

Synonym: L<upcase|Data::Sah::Filter::js::Str::upcase>,
L<uppercase|Data::Sah::Filter::js::Str::uppercase>.
