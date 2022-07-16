package Data::Sah::Filter::perl::Str::check;

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
        summary => 'Perform some checks',
        might_fail => 1,
        args => {
            min_len => {
                schema => 'uint*',
            },
            max_len => {
                schema => 'uint*',
            },
            match => {
                schema => 're*',
            },
            in => {
                schema => ['array*', of=>'str*'],
            },
        },
        examples => [
            {value=>"123", filter_args=>{max_len=>3}, valid=>1},
            {value=>"12345", filter_args=>{max_len=>3}, valid=>0},
        ],
        description => <<'_',

This is more or less a demo filter rule, to show how a filter rule can be used
to perform some checks. The standard checks performed by this rule, however, are
better done using standard <pm:Sah> schema clauses like `in`, `min_len`, etc.

_
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $gen_args = $fargs{args} // {};

    my @check_exprs;
    if (defined $gen_args->{min_len}) {
        my $val = $gen_args->{min_len} + 0;
        push @check_exprs, (@check_exprs ? "elsif" : "if") . qq( (length(\$tmp) < $val) { ["Length of data must be at least $val", \$tmp] } );
    }
    if (defined $gen_args->{max_len}) {
        my $val = $gen_args->{max_len} + 0;
        push @check_exprs, (@check_exprs ? "elsif" : "if") . qq( (length(\$tmp) > $val) { ["Length of data must be at most $val", \$tmp] } );
    }
    if (defined $gen_args->{match}) {
        my $val = ref $gen_args->{match} eq 'Regexp' ? $gen_args->{match} : qr/$gen_args->{match}/;
        push @check_exprs, (@check_exprs ? "elsif" : "if") . qq| (\$tmp !~ |.dmp($val).qq|) { ["Data must match $val", \$tmp] } |;
    }
    if (defined $gen_args->{in}) {
        my $val = $gen_args->{in};
        push @check_exprs, (@check_exprs ? "elsif" : "if") . qq| (!grep { \$_ eq \$tmp } \@{ |.dmp($val).qq| }) { ["Data must be one of ".join(", ", \@{|.dmp($val).qq|}), \$tmp] } |;
    }
    unless (@check_exprs) {
        push @check_exprs, qq(if (0) { } );
    }
    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do {",
        "    my \$tmp = $dt; ",
        @check_exprs,
        "    else { [undef, \$tmp] } ",
        "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$
