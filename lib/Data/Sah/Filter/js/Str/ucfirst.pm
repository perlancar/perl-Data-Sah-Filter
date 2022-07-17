package Data::Sah::Filter::js::Str::ucfirst;

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
        summary => 'Convert first character of string to uppercase',
        target_type => 'str',
        examples => [
            {value=>'foo', filtered_value=>'Foo'},
            {value=>'Foo'},
            {value=>'fOO', filtered_value=>'FOO'},
            {value=>'FOO'},
        ],
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    $res->{expr_filter} = "(function (_m) { _m = $dt; return _m.charAt(0).toUpperCase() + _m.substring(1) })()";

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

Related filters: L<lcfirst|Data::Sah::Filter::js::Str::lcfirst>.
