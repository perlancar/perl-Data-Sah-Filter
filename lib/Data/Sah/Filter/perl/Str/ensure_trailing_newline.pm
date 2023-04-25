package Data::Sah::Filter::perl::Str::ensure_trailing_newline;

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
        summary => 'Make sure string (except an empty one) ends with newline, add newline if the string does not',
        examples => [
            {value=>''},
            {value=>' ', filtered_value=>" \n"},
            {value=>'foo', filtered_value=>"foo\n"},
            {value=>'foo ', filtered_value=>"foo \n"},
            {value=>"foo\n"},
            {value=>"foo\n\n"},
            {value=>"foo\n ", filtered_value=>"foo\n \n"},
        ],
    };
}

sub filter {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { my \$res = $dt; \$res .= \"\\n\" unless \$res eq '' || \$res =~ /\\R\\z/; \$res }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO

L<Data::Sah::Filter::perl::Str::trim>
