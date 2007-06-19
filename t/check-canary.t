#!/usr/bin/env perl
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

use strict;
use warnings;
use Test::More tests => 8;

use Test::WWW::Mechanize::Catalyst 't::lib::TestApp';

my $error;
{ no warnings 'redefine';
  sub Catalyst::Log::error { $error = $_[1]; return }
}

my $mech = Test::WWW::Mechanize::Catalyst->new;
$mech->get_ok('http://whatever/one_form');

my $content = $mech->content;
my ($canary_key, $canary_value) = 
  ($content =~ /name="canary_([^"]+)".*value="([^"]+)"/);

ok($canary_key, 'got canary key');
ok($canary_value, 'got canary value');

$mech->get('http://whatever/one_form?foo=bar&baz=quux');
ok(!$mech->success, 'request should have failed without the canary');
like($error, qr/No canaries found/);

$mech->get_ok("http://whatever/one_form?foo=bar&baz=quux&".
              "canary_$canary_key=$canary_value",
              'but when canary is provided, all is well');

$mech->get("http://whatever/one_form?foo=bar&baz=quux&".
           "canary_$canary_key=$canary_value");
ok(!$mech->success, 'canary only works once');
like($error, qr/Invalid canary in form submission.  Aborting./);

