package Data::Sah::Filter::perl::Str::lcfirst;

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
        summary => 'Convert first character of string to lowercase',
        examples => [
            {value=>'foo'},
            {value=>'Foo', filtered_value=>'foo'},
            {value=>'FOO', filtered_value=>'fOO'},
        ],
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "lcfirst($dt)",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

Related filters: L<ucfirst|Data::Sah::Filter::perl::Str::ucfirst>.
