# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package t::lib::TestApp;
use strict;
use warnings;

use Catalyst qw(Session Session::State::Cookie Session::Store::Dummy FormCanary);

__PACKAGE__->setup;

1;
