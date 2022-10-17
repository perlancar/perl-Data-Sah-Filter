package Data::Sah::Filter::perl::Str::try_center;

use 5.010001;
use strict;
use warnings;

use Data::Dmp;

# AUTHORITY
# DATE
# DIST
# VERSION

sub meta {
    +{
        v => 1,
        summary => 'Try to center string in a width, fail if string is too long',
        might_fail => 1,
        args => {
            width => {
                schema => 'uint*',
                req => 1,
            },
        },
        examples => [
            {value=>"12", filter_args=>{width=>4}, validated_value=>" 12 "},
            {value=>"12", filter_args=>{width=>3}, validated_value=>"12 "},
            {value=>"12", filter_args=>{width=>2}, validated_value=>"12"},
            {value=>"12", filter_args=>{width=>1}, valid=>0},
        ],
        description => <<'_',

This filter is mainly for testing.

_
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $gen_args = $fargs{args} // {};
    my $width = int($gen_args->{width});

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do {\n",
        "  my \$tmp = $dt;\n",
        "  my \$l = $width - length(\$tmp);\n",
        "  if (\$l < 0) { ['String is too wide for width', \$tmp] }\n",
        "  else { my \$l1 = int(\$l/2); my \$l2 = \$l - \$l1; [undef, (' ' x \$l1) . \$tmp . (' ' x \$l2)] }\n",
        "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$
