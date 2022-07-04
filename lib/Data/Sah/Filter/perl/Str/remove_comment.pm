package Data::Sah::Filter::perl::Str::remove_comment;

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
        summary => 'Remove comment',
        args => {
            style => {
                schema => ['str*', in=>['shell', 'cpp']],
                default => 'shell',
            },
        },
    };
}

sub filter {
    my %fargs = @_;

    my $dt = $fargs{data_term};
    my $gen_args = $fargs{args} // {};
    $gen_args->{style} //= 'shell';

    my $res = {};
    $res->{expr_filter} = join(
        "",
        "do { ", (
            "my \$tmp = $dt; ",
            ($gen_args->{style} eq 'shell' ? "\$tmp =~ s/\\s*#.*//g; " :
             $gen_args->{style} eq 'cpp' ? "\$tmp =~ s!\\s*//.*!!g; " :
             die "Unknown style '$gen_args->{style}'"),
            "\$tmp ",
        ), "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|filter)$

=head1 SEE ALSO
