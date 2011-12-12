#!/usr/bin/env perl

use Dancer;
use Flowers;
use Plack::Builder;

my $app = sub {
    my $env = shift;
    my $request = Dancer::Request->new(env => $env);
    Dancer->dance($request);
};

builder {
    my $dancer_env;
    
    Dancer::Config::load();
    $dancer_env = Dancer::Config::setting('environment');
    
    enable_if {$dancer_env ne 'production'} "Auth::Htpasswd", file => 'run/.htpasswd';
    
    $app;
};


