package Flowers::Routes::Item;

use strict;
use Dancer ':syntax';
use Flowers::Products qw(product);

get '/product/:seo/:sku' => sub {
    my $product = product(
        uc params->{sku},
    );
    if (ref $product eq 'ARRAY') {
        $product = $product->[0];
    }

    debug 'product ', $product;
    template 'product', $product;
};

true;
