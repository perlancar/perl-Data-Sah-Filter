package Data::Sah::FilterCommon;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict 'subs', 'vars';
use warnings;

our %SPEC;

$SPEC{get_filter_rules} = {
    v => 1.1,
    summary => 'Get filter rules from filter rule modules',
    args => {
        filter_names => {
            schema => ['array*', of=>'str*'],
            req => 1,
        },
        compiler => {
            schema => 'str*',
            req => 1,
        },
        data_term => {
            schema => 'str*',
            req => 1,
        },
    },
};
sub get_filter_rules {
    my %args = @_;

    my $compiler = $args{compiler};
    my $dt       = $args{data_term};
    my $prefix = "Data::Sah::Filter::$compiler\::";

    my @rules;
    for my $filter_name (@{ $args{filter_names} }) {
        my $mod = $prefix . $filter_name;
        (my $mod_pm = "$mod.pm") =~ s!::!/!g;
        require $mod_pm;
        my $filter_meta = &{"$mod\::meta"};
        my $filter_v = ($filter_meta->{v} // 1);
        if ($filter_v != 1) {
            die "Only filter module following metadata version 1 is ".
                "supported, this filter module '$mod' follows metadata version ".
                "$filter_v and cannot be used";
        }
        my $rule = &{"$mod\::filter"}(
            data_term => $dt,
        );
        $rule->{name} = $filter_name;
        $rule->{meta} = $filter_meta;
        push @rules, $rule;
    }

    \@rules;
}

1;
# ABSTRACT: Common stuffs for Data::Sah::Filter and Data::Sah::FilterJS
