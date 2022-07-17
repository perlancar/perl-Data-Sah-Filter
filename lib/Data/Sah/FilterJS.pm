package Data::Sah::FilterJS;

use 5.010001;
use strict;
use warnings;
use Log::ger;

use Data::Sah::FilterCommon;
use Exporter qw(import);
use IPC::System::Options;
use Nodejs::Util qw(get_nodejs_path);

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
        compiler=>'js',
        data_term=>'data',
    );

    my $code;
    if (@$rules) {
        $code = join(
            "",
            "function (data) {\n",
            "    if (data === undefined || data === null) {\n",
            "        return null;\n",
            "    }\n",
        );
        for my $rule (@$rules) {
            if ($rule->{meta}{might_fail}) {
                if ($rt eq 'val') {
                    $code .= "    tmp = $rule->{expr_filter}; if (tmp[0]) { return null; } data = tmp[1]\n";
                } else {
                    $code .= "    tmp = $rule->{expr_filter}; if (tmp[0]) { return tmp; }  data = tmp[1]\n";
                }
            } else {
                if ($rt eq 'val') {
                    $code .= "    data = $rule->{expr_filter}\n";
                } else {
                    $code .= "    data = [false, $rule->{expr_filter}]\n";
                }
            }
        }
        $code .= join(
            '',
            "    return data;\n",
            "}",
        );
    } else {
        $code = 'function (data) { return data }';
    }

    if ($Log_Filter_Code) {
        log_trace("Filter code (gen args: %s): %s", \%args, $code);
    }

    return $code if $args{source};

    state $nodejs_path = get_nodejs_path();
    die "Can't find node.js in PATH" unless $nodejs_path;

    sub {
        require File::Temp;
        require JSON;
        #require String::ShellQuote;

        my $data = shift;

        state $json = JSON->new->allow_nonref;

        # code to be sent to nodejs
        my $src = "var filter = $code;\n\n".
            "console.log(JSON.stringify(filter(".
                $json->encode($data).")))";

        my ($jsh, $jsfn) = File::Temp::tempfile();
        print $jsh $src;
        close($jsh) or die "Can't write JS code to file $jsfn: $!";

        my $out = IPC::System::Options::readpipe($nodejs_path, $jsfn);
        $json->decode($out);
    };
}

1;
# ABSTRACT:

=head1 SYNOPSIS

 use Data::Sah::FilterJS qw(gen_filter);

 # use as you would use Data::Sah::Filter


=head1 DESCRIPTION

This module is just like L<Data::Sah::Filter> except that it uses JavaScript
filter rule modules.


=head1 VARIABLES

=head2 $Log_Filter_Code => bool (default: from ENV or 0)

If set to true, will log the generated filter code (currently using L<Log::ger>
at trace level). To see the log message, e.g. to the screen, you can use
something like:

 % TRACE=1 perl -MLog::ger::LevelFromEnv -MLog::ger::Output=Screen \
     -MData::Sah::FilterJS=gen_filter -E'my $c = gen_filter(...)'


=head1 ENVIRONMENT

=head2 LOG_SAH_FILTER_CODE => bool

Set default for C<$Log_Filter_Code>.


=head1 SEE ALSO

L<Data::Sah::Filter>

L<App::SahUtils>, including L<filter-with-sah> to conveniently test filtering
from the command-line.
