package Flowers;

use Dancer ':syntax';
use Dancer::Plugin::Form;
use Dancer::Plugin::Nitesi;
#use Dancer::Plugin::Nitesi::Routes;
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Auth::Extensible qw(
logged_in_user authenticate_user user_has_role require_role
require_login require_any_role
);
use Flowers::Products qw/product product_list/;
use Flowers::Routes::Account;
use Flowers::Routes::Checkout;
use Flowers::Routes::Item;
use Flowers::Routes::Payment;
use Flowers::Routes::Search;

our $VERSION = '0.0001';

hook 'before_layout_render' => sub {
	my $tokens = shift;
    my $action = '';

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

# fixme login/logout button
    if (! logged_in_user){
        $action = 'top-login';
    } else {
        $action ='top-logout';
};

   my $auth = schema->resultset('Navigation')->search(
         {
          scope => $action,
         },
    );
    while (my $record= $auth->next) {
         push @{$tokens->{'auth-' . $action}}, $record;
    };
};

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

get '/login/denied' => sub {
    template 'login_denied', , {layout_noleft => 1,
        layout_noright => 1};
};

get '/login' => sub {
    template 'login', {layout_noleft => 1,
        layout_noright => 1};
};

get '/forum' => require_login sub { 
    template 'forum', {layout_noleft => 1,
        layout_noright => 1};
     };

get '/admin' => require_role admin => sub { 
    template 'admin', {layout_noleft => 1,
        layout_noright => 1}; 
};

#shop_setup_routes;

true; 

=head1 NAME

Flowers - Flowers Website

=cut
