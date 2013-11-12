package Flowers;

use Dancer ':syntax';
use Dancer::Plugin::Form;
use Dancer::Plugin::Nitesi;
use Dancer::Plugin::Nitesi::Routes;
use Dancer::Plugin::DBIC qw( schema rset );
use Dancer::Plugin::Auth::Extensible;
use Dancer::Plugin::Auth::Extensible::Provider::DBIC;
use Flowers::Products qw/product product_list/;
use DateTime qw();
use DateTime::Duration qw();
use Flowers::Routes::Account;
use Flowers::Routes::Checkout;
use Flowers::Routes::Item;
use Flowers::Routes::Payment;
use Flowers::Routes::Search;

our $VERSION = '0.0001';

 my $now = DateTime->now;

my $admin_user =
        rset('User')
        ->create(
        { username => 'admin', password => 'admin', email => 'admin@localhost', created => $now } );

hook 'before_layout_render' => sub {
	my $tokens = shift;

	my $nav = schema->resultset('Navigation')->search(
		 {
		  type => 'nav',
		 },
		 {
          order_by => { -asc => 'priority'},
         }
    );

    while (my $record = $nav->next) {
         push @{$tokens->{'nav-' . $record->scope}}, $record;
    };
};



hook 'before_template' => sub {
    my $tokens = shift;

    $tokens->{form} ||= form;
    $tokens->{total} = cart->total;
#    $tokens->{main_menu} = query->select(table => 'navigation',
#					 type => 'category',
#					 where => {});
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
