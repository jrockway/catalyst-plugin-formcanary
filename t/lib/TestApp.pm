# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package t::lib::TestApp;
use strict;
use warnings;

use Catalyst qw(Session Session::State::Cookie Session::Store::Dummy FormCanary);

__PACKAGE__->config->{session}{expires} = 1000000000000; # forever
__PACKAGE__->setup;

1;
