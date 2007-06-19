#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Catalyst::Plugin::FormCanary' );
}

diag( "Testing Catalyst::Plugin::FormCanary $Catalyst::Plugin::FormCanary::VERSION, Perl $], $^X" );
