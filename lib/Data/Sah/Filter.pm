package Data::Sah::Filter;

use strict 'subs', 'vars';
use warnings;
no warnings 'once';
use Log::ger;

use Data::Sah::FilterCommon;
use Exporter qw(import);

# AUTHORITY
# DATE
# DIST
# VERSION

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
        %Data::Sah::FilterCommon::gen_filter_args,
    },
    result_naked => 1,
};
sub gen_filter {
    my %args = @_;

    my $rt = $args{return_type} // 'val';

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

        my $code_filter = "";
        my $has_defined_tmp;
        for my $rule (@$rules) {
            if ($rule->{meta}{might_fail}) {
                $code_filter .= "    my \$tmp;\n" unless $has_defined_tmp++;
                $code_filter .= "    \$tmp = $rule->{expr_filter};\n";
                if ($rt eq 'val') {
                    $code_filter .= "    return undef if \$tmp->[0];\n";
                } else {
                    $code_filter .= "    return \$tmp if \$tmp->[0];\n";
                }
                $code_filter .= "    \$data = \$tmp->[1];\n";
            } else {
                $code_filter .= "    \$data = $rule->{expr_filter};\n";
            }
        }

        $code = join(
            "",
            $code_require,
            "sub {\n",
            "    my \$data = shift;\n",
            "    unless (defined \$data) {\n",
            "        return ", ($rt eq 'val' ? "undef" : "[undef, undef]"), "\n",
            "    }\n",
            $code_filter, "\n",
            "    ", ($rt eq 'val' ? "\$data" : "[undef, \$data]"), ";\n",
            "}",
        );
    } else {
        if ($rt eq 'val') {
            $code = 'sub { $_[0] }';
        } else {
            $code = 'sub { [undef, $_[0]] }';
        }
    }

    if ($Log_Filter_Code) {
        log_trace("Filter code (gen args: %s): %s", \%args, $code);
    }

    return $code if $args{source};

    my $filter = eval $code; ## no critic: BuiltinFunctions::ProhibitStringyEval
    die if $@;
    $filter;
}

1;
# ABSTRACT: Filtering for Data::Sah

=for Pod::Coverage ^(.+)$

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

=head2 meta()

The filter rule module must contain C<meta> subroutine which must return a
hashref (L<DefHash>) that has the following keys (C<*> marks that the key is
required):

=over

=item * v* => int (default: 1)

Metadata specification version. From L<DefHash>. Currently at 1.

=item * summary => str

From L<DefHash>.

=item * might_fail => bool

Whether coercion might fail, e.g. because of invalid input. If set to 1,
C<expr_filter> key that the C<filter()> routine returns must be an expression
that returns an array (envelope) of C<< (error_msg, data) >> instead of just
filtered data. Error message should be a string that is set when filtering fails
and explains why. Otherwise, if filtering succeeds, the error message string
should be set to undefined value.

This is used for filtering rules that act as a data checker.

=item * args => hash

List of arguments that this filter accepts, in the form of hash where hash keys
are argument names and hash values are argument specifications. Argument
specification is a L<DefHash> similar to argument specification for functions in
L<Rinci::function> specification.

=back

=head2 filter()

The filter rule module must also contain C<filter> subroutine which must
generate the code for filtering. The subroutine must accept a hash of arguments
and will be passed these:

=over

=item * data_term => str

=item * args => hash

The arguments for the filter. Hash keys will contain the argument names, while
hash values will contain the argument's values.

=back

The C<filter> subroutine must return a hashref with the following keys (C<*>
indicates required keys):

=over

=item * expr_filter* => str

Expression in the target language to actually convert data.

=item * modules => hash

A list of modules required by the expression, where hash keys are module names
and hash values are modules' minimum versions.

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

=head2 Filter modules included in this distribution

# INSERT_MODULES_LIST /^Data::Sah::Filter::/


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
