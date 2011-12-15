package Flowers::Routes::Cart;

use Dancer ':syntax';
use Dancer::Plugin::Nitesi;

use Flowers::Products qw/product/;

post '/cart' => sub {
    my $input = params('body')->{sku};
    my ($sku, $product);
    
    if (ref($input) eq 'ARRAY') {
	$sku = $input->[0];
    }
    else {
	$sku = $input;
    }

    $product = product($sku);

    cart->add($product);

    debug("Items in cart: ", cart->items);
    
    redirect "/$sku";
};

true
