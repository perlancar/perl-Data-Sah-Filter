package Data::Sah::Filter::perl::Str::replace_map;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use Data::Dmp;

sub meta {
    +{
        v => 1,
        summary => 'Replace (map) some values with (to) other values',
        args => {
            map => {
                schema => 'hash*',
                req => 1,
            },
        },
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $gen_args = $fargs{args} // {};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do {",
        "    my \$tmp = $dt; ",
        "    my \$map = ".dmp($gen_args->{map})."; ",
        "    defined \$map->{\$tmp} ? \$map->{\$tmp} : \$tmp; ",
        "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 DESCRIPTION

This filter rule can be used to replace some (e.g. old) values to other (e.g.
new) values. For example, with this rule:

 [replace_map => {map => {burma => "myanmar", siam => "thailand"}}]

then "indonesia" or "myanmar" will be unchanged, but "burma" will be changed to
"myanmar" and "siam" will be changed to "thailand".


=head1 SEE ALSO

L<Complete::Util>'s L<complete_array_elem|Complete::Util/complete_array_elem>
also has a C<replace_map> option.
