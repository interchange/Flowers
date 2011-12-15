package VSC::Routes::Search;

use Dancer ':syntax';
use Dancer::Plugin::Nitesi;

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

	return template 'listing', {categories => $categories,
				    message => $message,
	}
    }

    $criteria = {title => {'-like'  => "%$q%"},
		 ldescription => {'-like'  => "%$q%"},
		 sku => {'-like'  => "%$q%"},
    };

    # search products
    $products = query->select(table => 'products',
			      fields => [qw/sku title price ldescription/],
			      where => [-and => [-not_bool => 'inactive',
						 [-or => $criteria
					]]],
			      order => 'title',
			      limit => 200,
	);

    debug("Products found for $q: ", scalar(@$products));

    template 'listing', {categories => $categories,
			 collections => $collections,
			 collections_count => $collections_count,
			 products => $products,
			 products_count => $products_count,
			 message => $message,
    };
};

1;
