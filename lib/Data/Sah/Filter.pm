package Data::Sah::Filter;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict 'subs', 'vars';
use warnings;
no warnings 'once';
use Log::ger;

use Data::Sah::FilterCommon;

use Exporter qw(import);
our @EXPORT_OK = qw(gen_filter);

our %SPEC;

our $Log_Filter_Code = $ENV{LOG_SAH_FILTER_CODE} // 0;

$SPEC{gen_filter} = {
    v => 1.1,
    summary => 'Generate filter code',
    description => <<'_',

This is mostly for testing. Normally the filter rules will be used from
<pm:Data::Sah>.

_
    args => {
        filter_names => {
            schema => ['array*', of=>'str*'],
        },
    },
    result_naked => 1,
};
sub gen_filter {
    my %args = @_;

    my $rules = Data::Sah::FilterCommon::get_filter_rules(
        %args,
        compiler=>'perl',
        data_term=>'$data',
    );

    my $code;
    if (@$rules) {
        my $code_require = '';
        my %mem;
        for my $rule (@$rules) {
            next unless $rule->{modules};
            for my $mod (keys %{$rule->{modules}}) {
                next if $mem{$mod}++;
                $code_require .= "require $mod;\n";
            }
        }

        $code = join(
            "",
            $code_require,
            "sub {\n",
            "    my \$data = shift;\n",
            "    unless (defined \$data) {\n",
            "        return undef;\n",
            "    }\n",
            (map { "    \$data = $_->{expr_filter};\n" } @$rules),
            "}",
        );
    } else {
        $code = 'sub { $_[0] }';
    }

    if ($Log_Filter_Code) {
        log_trace("Filter code (gen args: %s): %s", \%args, $code);
    }

    return $code if $args{source};

    my $filter = eval $code;
    die if $@;
    $filter;
}

1;
# ABSTRACT: Filtering for Data::Sah

=head1 SYNOPSIS

 use Data::Sah::Filter qw(gen_filter);

 # a utility routine: gen_filter
 my $c = gen_filter(
     filter_names       => ['Str::ltrim', 'Str::rtrim'],
 );

 my $val = $c->("foo");        # unchanged, "foo"
 my $val = $c->(" foo ");      # "foo"


=head1 DESCRIPTION

This distribution contains a standard set of filter rules for L<Data::Sah> (to
be used in C<prefilters> and C<postfilter> cause). It is separated from the
C<Data-Sah> distribution and can be used independently.

A filter rule is put in C<Data::Sah::Filter::$COMPILER::$CATEGORY:$DESCRIPTION>
module, for example: L<Data::Sah::Filter::perl::Str::trim> for trimming
whitespace at the beginning and end of string.

Basically, a filter rule will provide an expression (C<expr_filter>) to convert
data to another. Multiple filter rules will be combined to form the final
filtering code.

The filter rule module must contain C<meta> subroutine which must return a
hashref (L<DefHash>) that has the following keys (C<*> marks that the key is
required):

=over

=item * v* => int (default: 1)

Metadata specification version. From L<DefHash>. Currently at 1.

=item * summary => str

From L<DefHash>.

=back

The filter rule module must also contain C<filter> subroutine which must
generate the code for filtering. The subroutine must accept a hash of arguments
(C<*> indicates required arguments):

=over

=item * data_term => str

=back

The C<filter> subroutine must return a hashref with the following keys (C<*>
indicates required keys):

=over

=item * expr_filter => str

Expression in the target language to actually convert data.

=item * modules => hash

A list of modules required by the expression.

=back

Basically, the C<filter> subroutine must generate a code that accepts a
non-undef data and must convert this data to the desired value.

Program/library that uses L<Data::Sah::Filter> can collect rules from the rule
modules then compose them into the final code, something like (in pseudo-Perl
code):

 if (!defined $data) {
   return undef;
 } else {
   $data = expr-filter-from-rule1($data);
   $data = expr-filter-from-rule2($data);
   ...
   return $data;
 }


=head1 VARIABLES

=head2 $Log_Filter_Code => bool (default: from ENV or 0)

If set to true, will log the generated filter code (currently using L<Log::ger>
at trace level). To see the log message, e.g. to the screen, you can use
something like:

 % TRACE=1 perl -MLog::ger::LevelFromEnv -MLog::ger::Output=Screen \
     -MData::Sah::Filter=gen_filter -E'my $c = gen_filter(...)'


=head1 ENVIRONMENT

=head2 LOG_SAH_FILTER_CODE => bool

Set default for C<$Log_Filter_Code>.


=head1 SEE ALSO

L<Data::Sah>

L<Data::Sah::FilterJS>

L<App::SahUtils>, including L<filter-with-sah> to conveniently test filter from
the command-line.

L<Data::Sah::Coerce>. Filtering works very similarly to coercion in the
L<Data::Sah> framework (see l<Data::Sah::Coerce>) but is simpler and composited
differently to form the final filtering code. Mainly, input data will be passed
to all filtering expressions.
