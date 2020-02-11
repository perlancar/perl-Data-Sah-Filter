package Data::Sah::FilterCommon;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict 'subs', 'vars';
use warnings;

our %SPEC;

our %common_args = (
    filter_names => {
        schema => ['array*', of=>'str*'],
        req => 1,
    },
);

our %gen_filter_args = (
    %common_args,
    return_type => {
        schema => ['str*', in=>['val', 'errstr+val']],
        default => 'val',
    },
);

$SPEC{get_filter_rules} = {
    v => 1.1,
    summary => 'Get filter rules from filter rule modules',
    args => {
        %common_args,
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
    for my $entry (@{ $args{filter_names} }) {
        my $filter_name = ref $entry eq 'ARRAY' ? $entry->[0] : $entry;
        my $filter_gen_args = ref $entry eq 'ARRAY' ? $entry->[1] : undef;

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
            (args => $filter_gen_args) x !!$filter_gen_args,
        );
        $rule->{name} = $filter_name;
        $rule->{meta} = $filter_meta;
        push @rules, $rule;
    }

    \@rules;
}

1;
# ABSTRACT: Common stuffs for Data::Sah::Filter and Data::Sah::FilterJS
