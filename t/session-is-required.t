#!/usr/bin/env perl
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

use strict;
use warnings;
use Test::Exception;
use Test::More tests => 4;

use ok 't::lib::GoodApp';
use ok 't::lib::BadApp';

throws_ok { t::lib::BadApp->setup } qr/setup Catalyst::Plugin::Session before/,
  'BadApp->setup fails';

lives_ok { t::lib::GoodApp->setup } 'GoodApp->setup lives';

