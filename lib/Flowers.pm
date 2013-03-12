package Flowers;

use Dancer ':syntax';
use Dancer::Plugin::Form;
use Dancer::Plugin::Nitesi;

use Flowers::Navigation;
use Flowers::Products qw/product product_list/;

use Flowers::Routes::Account;
use Flowers::Routes::Cart;
use Flowers::Routes::Checkout;
use Flowers::Routes::Payment;
use Flowers::Routes::Search;

our $VERSION = '0.0001';

hook 'before_template' => sub {
    my $tokens = shift;

    $tokens->{form} ||= form;
    $tokens->{total} = cart->total;
    $tokens->{main_menu} = query->select(table => 'navigation',
					 type => 'category',
					 where => {});					 
};

get qr{/?(?<path>.*)} => sub {
    my ($path, $nav, $ret, $rel, $prefix, $form, $products, $sort);

    $path = captures->{path};

    if (length($path) == 0) {
	$form = form('sort');
	$sort = param('sort');
	$form->fill(sort => $sort);
	
	$products = product_list(sort  => $sort);
    } elsif ($nav = navigation($path)) {
	$form = form('sort');
	$sort = param('sort');

	$products = $nav->products(sort => $sort);
    }
    elsif ($ret = product($path)) {
	# get related products
	if ($ret->{sku} =~ /^(.*?)(-[^-]*?)$/) {
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
	$products = [];
    }

    template 'listing', {products => $products, sort => $sort, form => $form};
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
