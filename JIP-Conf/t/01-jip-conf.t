#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use Test::More;
use English qw(-no_match_vars);

use_ok 'JIP::Conf';
require_ok 'JIP::Conf';

diag(
    sprintf 'Testing JIP::Conf %s, Perl %s, %s',
        $JIP::Conf::VERSION,
        $OLD_PERL_VERSION,
        $EXECUTABLE_NAME,
);

done_testing();

