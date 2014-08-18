package VSC::Routes::Search;

use Dancer ':syntax';
use Dancer::Plugin::Interchange6;

use Flowers::Products;

get '/search' => sub {
    my ($q, $categories, $collections, $collections_count, $products, $products_count, $message, $criteria);

    $q = params->{q};

    unless (defined $q) {
	    $q = '';
    }

    # sanity check on search term
    unless (length($q) >= 3) {
        $message = 'Please enter at least 3 characters for the search.';

        return template 'listing', {
            categories => $categories,
            message => $message,
        }
    }

    $criteria = {name => {'-like'  => "%$q%"},
		 description => {'-like'  => "%$q%"},
		 sku => {'-like'  => "%$q%"},
    };

    # search products
    $products = shop_product->search({-and => [-bool => 'active',
                                               canonical_sku => undef,
                                               [-or => $criteria
                                            ]]},
                                     {order_by => {-asc => 'name',}},
                                 );

    template 'listing', {categories => $categories,
			 collections => $collections,
			 collections_count => $collections_count,
			 products => $products,
			 count => $products->count,
			 message => $message,
    };
};

1;
