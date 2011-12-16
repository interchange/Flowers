package Flowers;

use Dancer ':syntax';
use Dancer::Plugin::Nitesi;

use Flowers::Products qw/product product_list/;

use Flowers::Routes::Account;
use Flowers::Routes::Cart;
use Flowers::Routes::Search;

our $VERSION = '0.0001';

hook 'before_template' => sub {
    my $tokens = shift;

    $tokens->{total} = cart->total;
};

get '/' => sub {
    # show all products
    template 'index', {products => product_list()};
};

get qr{/?(?<path>.*)} => sub {
    my ($path, $ret, $rel, $prefix);

    $path = captures->{path};

    if (navigation($path)) {
	debug ("path $path is valid.");
    }
    elsif ($ret = product($path)) {
	debug ("path $path is a product.");
	
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
	
	return template 'product', $ret;
    }
    else {
	debug("Catch all: ", captures->{path});
    }
    
    template 'index';
};

sub menu {
    # pulls out menu data from navigation table
};

sub _build_query_path {
    my ($path) = @_;
    my ($nav_config, %nav_parms);

    # defaults
    %nav_parms = (table => 'navigation',
		  uri_field => 'uri',
		  link_table => 'navigation_products',
		  link_field => 'navigation',
		  items_table => 'products',
		  items_link_field => 'sku',
	);

    # overrides from config
    $nav_config = config->{navigation}->{main};

    for (keys %$nav_config) {
	$nav_parms{$_} = $nav_config->{$_};
    }

    return (table => $nav_parms{table},
	    where => {$nav_parms{uri_field} => $path});
}

sub navigation {
    my ($path, $set);
    
    if (@_ == 1) {
	# just check whether path is available in navigation table
	$path = shift;

	$set = query->select(_build_query_path($path));

	if (@$set == 1) {
	    return $set->[0];
	}
    }
}

true; 

=head1 NAME

Flowers - Flowers Website

=cut
