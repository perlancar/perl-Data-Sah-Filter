package Data::Sah::Filter::perl::Str::downcase;

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
        summary => 'Convert string to lowercase',
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "lc($dt)",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

Related filters: L<upcase|Data::Sah::Filter::perl::Str::upcase>.

Synonyms: L<lc|Data::Sah::Filter::js::Str::lc>,
L<lowercase|Data::Sah::Filter::js::Str::lowercase>.
