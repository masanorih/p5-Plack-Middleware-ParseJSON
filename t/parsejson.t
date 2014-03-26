use strict;
use warnings;
use HTTP::Request::Common;
use JSON qw(to_json);
use Plack::Builder;
use Plack::Test;
use Test::More;

my $post_data = {
    foo => 'bar',
    aaa => 'bbb',
};

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    for my $key ( keys %{$post_data} ) {
        is $post_data->{$key}, $req->param($key);
    }
    [200, ['Content-Type' => 'text/plain', 'Content-Length' => 2], ['ok']];
};
$app = builder { enable "Plack::Middleware::ParseJSON"; $app };

test_psgi $app, sub {
    my $cb = shift;

    my $json = to_json($post_data);
    my $res = $cb->(POST "/",
        'Content-Type' => 'application/json', Content => $json );
    is $res->code, 200;
};

done_testing;
