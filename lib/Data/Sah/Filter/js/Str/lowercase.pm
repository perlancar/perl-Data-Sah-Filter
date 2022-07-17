package Data::Sah::Filter::js::Str::lowercase;

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
        target_type => 'str',
        examples => [
            {value=>'foo'},
            {value=>'Foo', filtered_value=>'foo'},
            {value=>'FOO', filtered_value=>'foo'},
        ],
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    $res->{expr_filter} = "$dt.toLowerCase()";

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

Related filters: L<uppercase|Data::Sah::Filter::js::Str::uppercase>.

Synonym: L<lc|Data::Sah::Filter::js::Str::lc>,
L<downcase|Data::Sah::Filter::js::Str::downcase>.
