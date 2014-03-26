use Test::More tests => 1;

BEGIN {
use_ok( 'Plack::Middleware::ParseJSON' );
}

diag( "Testing Plack::Middleware::ParseJSON $Plack::Middleware::ParseJSON::VERSION" );
