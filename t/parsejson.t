use strict;
use warnings;
use HTTP::Request::Common;
use JSON qw(to_json);
use Plack::Builder;
use Plack::Test;
use Test::More;
use URI::Escape qw(uri_unescape);

test_post({
    foo => 'bar',
    aaa => 'bbb',
});
# with escape string
test_post({
    'foo&' => 'foo&',
    'bar ' => 'bar ',
});
# utf8,shift_jis,euc-jp
test_post({
    utf8 => uri_unescape '%E3%82%A6%E3%82%A3%E3%82%AD%E3%83%9A%E3%83%87%E3%82%A3%E3%82%A2',
    sjis => uri_unescape '%83E%83B%83L%83y%83f%83B%83A',
    euc  => uri_unescape '%A5%A6%A5%A3%A5%AD%A5%DA%A5%C7%A5%A3%A5%A2'
});

sub test_post {
    my $post_data = shift;

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
}

done_testing;
