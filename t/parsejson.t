use strict;
use warnings;
use HTTP::Request::Common;
use JSON qw(from_json to_json);
use Plack::Builder;
use Plack::Test;
use Test::More;
use URI::Escape qw(uri_unescape);

subtest 'normal json' => sub {
    test_post(q!{
        "foo": "bar",
        "aaa": "bbb"
    }!);
};
subtest 'with escape string' => sub {
    test_post(q!{
        "foo&": "foo&",
        "bar ": "bar "
    }!);
};
subtest 'utf8, shift_jis, euc-jp' => sub {
    my $ref = {
        utf8 => uri_unescape '%E3%82%A6%E3%82%A3%E3%82%AD%E3%83%9A%E3%83%87%E3%82%A3%E3%82%A2',
        sjis => uri_unescape '%83E%83B%83L%83y%83f%83B%83A',
        euc  => uri_unescape '%A5%A6%A5%A3%A5%AD%A5%DA%A5%C7%A5%A3%A5%A2'
    };
    my $json = to_json $ref;
    test_post($json);
};
subtest 'array' => sub {
    test_post(q!{
        "a": "b",
        "c": [ "d", "e" ]
    }!);
};

sub test_post {
    my $json = shift;
    my $post = from_json($json);

    my $app = sub {
        my $env = shift;
        my $req = Plack::Request->new($env);
        for my $key ( keys %{$post} ) {
            my $val = $post->{$key};
            if ( 'ARRAY' eq ref $val ) {
                my @r = $req->param($key);
                is_deeply( $val, \@r, 'param list is ok' );
            }
            else {
                is $post->{$key}, $req->param($key), 'param is ok';
            }
        }
        [200, ['Content-Type' => 'text/plain', 'Content-Length' => 2], ['ok']];
    };
    $app = builder { enable "Plack::Middleware::ParseJSON"; $app };

    test_psgi $app, sub {
        my $cb = shift;
        my $res = $cb->(POST "/",
            'Content-Type' => 'application/json', Content => $json );
        is $res->code, 200, 'http code is 200';
    };
}

done_testing;
