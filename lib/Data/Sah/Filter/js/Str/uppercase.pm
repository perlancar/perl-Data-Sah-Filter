package Data::Sah::Filter::js::Str::uppercase;

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

Related filters: L<lowercase|Data::Sah::Filter::js::Str::lowercase>.

Synonym: L<uc|Data::Sah::Filter::js::Str::uc>,
L<upcase|Data::Sah::Filter::js::Str::upcase>.
