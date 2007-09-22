package Catalyst::Plugin::FormCanary;

use warnings;
use strict;
use Carp;

our $VERSION = '0.01';

sub setup {
    my $c = shift;
    
    $c->NEXT::setup(@_);
    
    croak 'please setup Catalyst::Plugin::Session before FormCanary'
      if !$c->can('session');
    
    return;
}

sub finalize_body {
    my $c = shift;

    # see if we should touch this
    my $content_type = $c->response->content_type || '';
    if ($content_type =~ /html/){ # xhtml+xml, html, etc.
        
        # generate some cryptographic tokens
        my $key    = $c->generate_session_id;
        my $canary = $c->generate_session_id;
        my $name   = "canary_$key";
        
        # store them in the session
        $c->session->{_formcanary} ||= {};
        $c->session->{_formcanary}{$key} = $canary;
        
        # add the input tags to the body
        my $body = $c->response->body;
        $body =~         # yuck.
          s{</form>}
           {<input type="hidden" name="$name" id="$name" value="$canary" />
            </form>}g;
        $c->response->body($body);
    }

    return $c->NEXT::finalize_body(@_);
}

sub prepare_action {
    my $c = shift;
    $c->NEXT::prepare_action(@_);
    $c->session;

    if (keys %{$c->request->params||{}}) {
        # there were some params, check canary
        my @canary_keys = 
          map {s/^canary_//; $_} grep {/^canary_/} keys %{$c->request->params||{}};

        # no canary, that's bad
        die "No canaries found" if !@canary_keys;

        # iterate over each and compare to the session
        my $success = 1;
        foreach my $key (@canary_keys) {
            my $stored   = delete $c->session->{_formcanary}{$key};
            my $provided = delete $c->request->params->{"canary_$key"};

            if (!defined $stored || !defined $provided || $stored ne $provided) 
              {
                  $success = 0;
                  last;
              }
        }
        
        # and die if one was invalid
        die "Invalid canary in form submission.  Aborting." if !$success;
    }
    
    return;
}

__END__

=head1 NAME

Catalyst::Plugin::FormCanary - check that forms are submitted from your site

=head1 SYNOPSIS

    use Catalyst qw(... Session ... FormCanary ...);

FormCanary will examine your outgoing HTML and add a canary value to
each form.  When the form is submitted, the value of the canary is
compared against one saved in the session at page generation time.  If
the canary that's sent doesn't match the one in the session (or there
is no canary at all), the request is halted.

There is no way to get params into your application without a correct
canary.  This is good for preventing "cross-site request attacks".

This module is compatible with FormBuilder.  Just drop it
into your use line and have secure submit-once-only forms.  Yay.

=head1 TODO

Don't delete the canary, in case resubmitting is OK.

Make this an ActionClass so you can apply the check to a single action
instead of everything.

Make the error nicer than C<die>.

=head1 DEPENDENCIES

You need L<Catalyst::Plugin::Session> up and running.

=head1 AUTHOR

Jonathan Rockway, C<< <jrockway at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-catalyst-plugin-formcanary at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-Plugin-FormCanary>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

L<irc://irc.perl.org/#catalyst> is also a good place to ask for help.

=head1 GIT

Clone from:

   git clone git://git.jrock.us/Catalyst-Plugin-FormCanary

Or view online at L<http://git.jrock.us/?p=Catalyst-Plugin-FormCanary.git>

=head1 ACKNOWLEDGEMENTS

This site gave me the idea:

L<http://www.25hoursaday.com/weblog/2007/06/05/WhatRubyOnRailsCanLearnFromASPNET.aspx>

=head1 COPYRIGHT & LICENSE

Copyright 2007 Jonathan Rockway, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Catalyst::Plugin::FormCanary
