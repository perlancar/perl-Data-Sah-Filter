package Data::Sah::Filter::perl::Str::lc;

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

Related filters: L<uc|Data::Sah::Filter::perl::Str::uc>.

Synonyms: L<lowercase|Data::Sah::Filter::js::Str::lowercase>,
L<downcase|Data::Sah::Filter::js::Str::downcase>.
