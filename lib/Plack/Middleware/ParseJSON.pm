package Plack::Middleware::ParseJSON;

use warnings;
use strict;
use Carp;
use version; our $VERSION = qv('0.0.1');
use parent qw(Plack::Middleware);
use JSON qw(from_json);
use Plack::Request;
use URI::Escape qw(uri_escape);

sub call {
    my($self, $env) = @_;
    my $req = Plack::Request->new($env);
    my $type = $req->content_type;
    if ( defined $type and $type =~ m!^application/json! ) {
        #warn "ParseJSON content = " . $req->content;
        my $json = from_json( $req->content );
        my @query;
        # XXX this version works only when json is a simple hash ref. XXX
        for my $key ( keys %{$json} ) {
            my $val = $json->{$key};
            push @query, sprintf( "%s=%s",
                uri_escape($key),
                uri_escape($val)
            );
        }
        $env->{QUERY_STRING} = join( '&', @query ) if @query;
        #warn "QUERY_STRING = " . $env->{QUERY_STRING};
    }
    $self->app->($env);
}

1;
__END__

=head1 NAME

Plack::Middleware::ParseJSON - Plack middleware for parsing JSON post data

=head1 VERSION

This document describes Plack::Middleware::ParseJSON version 0.0.1

=head1 SYNOPSIS

    # enable this middleware in your .psgi file
    builder {
        enable "Plack::Middleware::ParseJSON";
        $app;
    };

    my $val = $req->param('key1');

=head1 DESCRIPTION

This module is Plack middleware for parsing JSON post data
and set it to $env->{QUERY_STRING}.

I found that $http.post() of the AngularJS sends JSON as a post data
when the post data is a JavaScript object.

This module parses a JSON and set it to $env->{QUERY_STRING}.
Plack::Request treats $env->{QUERY_STRING} later
so your app can retrieve JSON data via $req->param('key');.

=back

=head1 CONFIGURATION AND ENVIRONMENT

Plack::Middleware::ParseJSON requires no configuration files or environment variables.

=head1 DEPENDENCIES

This module requires JSON, Plack.

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

This version works only when json is a simple hash ref.
Does not still work for multi-level json.

=head1 AUTHOR

Masanori Hara  C<< <massa.hara at gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2014, Masanori Hara C<< <massa.hara at gmail.com> >>.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
