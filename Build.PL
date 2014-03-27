use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Plack::Middleware::ParseJSON',
    license             => 'perl',
    dist_author         => 'Masanori Hara <massa.hara at gmail.com>',
    dist_version_from   => 'lib/Plack/Middleware/ParseJSON.pm',
    requires => {
        'Test::More'  => 0,
        'version'     => 0,
        'JSON'        => 0,
        'URI::Escape' => 0,
    },
    add_to_cleanup      => [ 'Plack-Middleware-ParseJSON-*' ],
);

$builder->create_build_script();
