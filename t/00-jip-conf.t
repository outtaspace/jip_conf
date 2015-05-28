#!/usr/bin/env perl

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
            $PERL_VERSION,
            $EXECUTABLE_NAME,
    );
};

subtest 'Make sure init() invocations with no args fail' => sub {
    plan tests => 4;

    eval { JIP::Conf::init() } or do {
        like $EVAL_ERROR, qr{^Bad \s argument \s "path_to_file"}x;
    };

    eval { JIP::Conf::init(q{}) } or do {
        like $EVAL_ERROR, qr{^Bad \s argument \s "path_to_file"}x;
    };

    eval { JIP::Conf::init(dist_file('JIP-Conf', 'well_formed.conf.pm')) } or do {
        like $EVAL_ERROR, qr{^Bad \s argument \s "path_to_variable"}x;
    };

    eval { JIP::Conf::init(dist_file('JIP-Conf', 'well_formed.conf.pm'), q{}) } or do {
        like $EVAL_ERROR, qr{^Bad \s argument \s "path_to_variable"}x;
    };
};

subtest 'Fail if file not exists/well-formed' => sub {
    plan tests => 3;

    eval { JIP::Conf::init('./unexisting_file', 'Config::hash_ref') } or do {
        like $EVAL_ERROR, qr{^No \s such \s file \s "./unexisting_file" \n}x;
    };

    eval { JIP::Conf::init(dist_file('JIP-Conf', 'syntax_error.conf.pm'), 'Config::hash_ref') } or do {
        like $EVAL_ERROR, qr{^Can't \s parse \s config}x;
    };

    eval { JIP::Conf::init(dist_file('JIP-Conf', 'well_formed.conf.pm'), 'Config::array_ref') } or do {
        like $EVAL_ERROR, qr/^Invalid \s config. \s Can't \s fetch \s \${Config::array_ref} \s from/x;
    };
};

subtest 'HASH from file' => sub {
    plan tests => 4;

    my $object = JIP::Conf::init(
        dist_file('JIP-Conf', 'well_formed.conf.pm'),
        'Config::hash_ref',
    );

    is $object->parent->first_child, 'tratata';
    is $object->parent->second_child, 'тратата';

    cmp_ok $object->{'parent'}->{'first_child'},  'eq', $object->parent->first_child;
    cmp_ok $object->{'parent'}->{'second_child'}, 'eq', $object->parent->second_child;
};

