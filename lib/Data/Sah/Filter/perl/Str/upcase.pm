package Data::Sah::Filter::perl::Str::upcase;

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
        summary => 'Convert string to uppercase (synonym for uc)',
        examples => [
            {value=>'foo', filtered_value=>'FOO'},
            {value=>'Foo', filtered_value=>'FOO'},
            {value=>'fOO', filtered_value=>'FOO'},
            {value=>'FOO'},
        ],
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "uc($dt)",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

Related filters: L<downcase|Data::Sah::Filter::perl::Str::downcase>.

Synonym: L<uc|Data::Sah::Filter::js::Str::uc>,
L<uppercase|Data::Sah::Filter::js::Str::uppercase>.
