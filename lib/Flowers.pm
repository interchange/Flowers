package Flowers;

use Dancer ':syntax';
use Dancer::Plugin::Form;
use Dancer::Plugin::Nitesi;
use Dancer::Plugin::Nitesi::Routes;

use Flowers::Products qw/product product_list/;

use Flowers::Routes::Account;
use Flowers::Routes::Checkout;
use Flowers::Routes::Item;
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

get '/' => sub {
    my ($form, $sort, $products);

    $form = form('sort');
	$sort = param('sort');
    $form->fill(sort => $sort);

    $products = product_list(sort  => $sort);

    template 'listing', {products => $products, sort => $sort, form => $form};
};

shop_setup_routes;

true; 

=head1 NAME

Flowers - Flowers Website

=cut
