#!/usr/bin/env perl

use Dancer;
use Flowers;
use Plack::Builder;

my $app = sub {
    my $env     = shift;
    my $request = Dancer::Request->new(env => $env);
    Dancer->dance($request);
};

builder {
	enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' } 
        	"Plack::Middleware::ReverseProxy";

    $app;
};

