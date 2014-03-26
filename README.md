p5-Plack-Middleware-ParseJSON
=============================

Plack middleware for parsing JSON post data

## ABOUT

This module is Plack middleware for parsing JSON post data
and set it to $env->{QUERY_STRING}.

I found that $http.post() of the AngularJS sends JSON as a post data
when the post data is a JavaScript object.

This module parses a JSON and set it to $env->{QUERY_STRING}.
Plack::Request treats $env->{QUERY_STRING} later
so your app can retrieve JSON data via $req->param('key'); .

## INSTALLATION

To install this module, run the following commands:

	perl Makefile.PL
	make
	make test
	make install

Alternatively, to install with Module::Build, you can use the following commands:

	perl Build.PL
	./Build
	./Build test
	./Build install


## DEPENDENCIES

This module requires JSON, Plack.

## COPYRIGHT AND LICENCE

Copyright (C) 2014, Masanori Hara

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
