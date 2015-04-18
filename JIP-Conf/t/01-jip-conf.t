use 5.006;
use utf8;
use strict;
use warnings FATAL => 'all';
use Test::More;
use English qw(-no_match_vars);
use File::ShareDir qw(dist_file);

plan tests => 4;

subtest 'Require some module' => sub {
    plan tests => 2;

    use_ok 'JIP::Conf', '0.01';
    require_ok 'JIP::Conf';

    diag(
        sprintf 'Testing JIP::Conf %s, Perl %s, %s',
            $JIP::Conf::VERSION,
            $OLD_PERL_VERSION,
            $EXECUTABLE_NAME,
    );
};

subtest 'Make sure init() invocations with no args fail' => sub {
    plan tests => 2;

    eval { JIP::Conf::init() };
    like $EVAL_ERROR, qr{^Bad \s argument \s "path"}x;

    eval { JIP::Conf::init(q{}) };
    like $EVAL_ERROR, qr{^Bad \s argument \s "path"}x;
};

subtest 'Fail if file not exists/well-formed' => sub {
    plan tests => 3;

    eval { JIP::Conf::init('./unexisting_file') };
    like $EVAL_ERROR, qr{^No \s such \s file \s "./unexisting_file" \n}x;

    eval { JIP::Conf::init(dist_file('JIP-Conf', 'syntax_error.conf.pm')) };
    like $EVAL_ERROR, qr{^Can't \s parse \s config}x;

    eval { JIP::Conf::init(dist_file('JIP-Conf', 'not_a_hashref.conf.pm')) };
    like $EVAL_ERROR, qr{^Invalid \s config}x;
};

subtest 'HASH from file' => sub {
    plan tests => 4;

    my $object = JIP::Conf::init(dist_file('JIP-Conf', 'well_formed.conf.pm'));

    is $object->parent->first_child, 'tratata';
    is $object->parent->second_child, 'тратата';

    cmp_ok $object->{'parent'}->{'first_child'},  'eq', $object->parent->first_child;
    cmp_ok $object->{'parent'}->{'second_child'}, 'eq', $object->parent->second_child;
};

