package Flowers;

use Dancer ':syntax';
use Dancer::Plugin::Nitesi;

use Flowers::Navigation;
use Flowers::Products qw/product product_list/;

use Flowers::Routes::Account;
use Flowers::Routes::Cart;
use Flowers::Routes::Checkout;
use Flowers::Routes::Search;

our $VERSION = '0.0001';

hook 'before_template' => sub {
    my $tokens = shift;

    $tokens->{total} = cart->total;
    $tokens->{main_menu} = query->select(table => 'navigation',
					 type => 'category',
					 where => {});					 
};

get '/' => sub {
    # show all products
    template 'index', {products => product_list()};
};

get qr{/?(?<path>.*)} => sub {
    my ($path, $nav, $ret, $rel, $prefix, $products);

    $path = captures->{path};

    if ($nav = navigation($path)) {
	$products = $nav->products;
    }
    elsif ($ret = product($path)) {
	# get related products
	if ($ret->{sku} =~ /^(.*?)(-[^-]*?)$/) {
	    debug ("search for related products: $1 from $ret->{sku}.");
	    $prefix = $1;
	    $rel = query->select(table => 'products',
				 fields => [qw/sku name price/],
				 where => {sku => {'-like' => "$prefix%"}},
				 order => 'price asc',
		);

	    $ret->{options} = $rel;
	}

	# no right sidebar
	$ret->{layout_noright} = 1;
	
	return template 'product', $ret;
    }
    else {
	debug("Catch all: ", captures->{path});
    }
    
    template 'index', {products => $products};
};

sub menu {
    # pulls out menu data from navigation table
};

sub navigation {
    my $path = shift;
    my $nav;
    
    $nav = Flowers::Navigation->new(uri => $path);

    if ($nav->code && ! $nav->inactive) {
	return $nav;
    }

    return;
}

true; 

=head1 NAME

Flowers - Flowers Website

=cut
