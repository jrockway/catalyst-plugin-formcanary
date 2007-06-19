# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package t::lib::TestApp::Controller::Root;
use strict;
use warnings;
__PACKAGE__->config(namespace => q{});

use base 'Catalyst::Controller';

sub not_html :Local {
    my ($self, $c) = @_;
    $c->res->content_type('text/plain');
    $c->res->body(basic_form());
}

sub one_form :Local {
    my ($self, $c) = @_;
    $c->res->content_type('text/html');
    $c->res->body(basic_form());
}

sub two_forms :Local {
    my ($self, $c) = @_;
    $c->res->content_type('text/html');
    $c->res->body(two_basic_forms());
}

sub basic_form {
    return<<'HTML'
<html>
<head><title>Test</title></head>
<body>
 <h1>Hello</h1>
 <p>This is a test page.  If you are seeing this you are weird.</p>
 <form action="who cares" method="also not relevant">
  <input type="hidden" name="foo" value="foo" id="foo" />
 </form>
</body>
</html>
HTML
}

sub two_basic_forms {
        return<<'HTML'
<html>
<head><title>Test</title></head>
<body>
 <h1>Hello</h1>
 <p>This is a test page.  If you are seeing this you are weird.</p>
 <form action="who cares" method="also not relevant">
  <input type="hidden" name="foo" value="foo" id="foo" />
 </form>
 <form action="another" method="POST">
  <input type="hidden" name="foo" value="foo" id="foo" />
 </form>
</body>
</html>
HTML
}

1;
