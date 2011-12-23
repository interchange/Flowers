package Flowers::Navigation;

use strict;
use warnings;

use base 'Nitesi::Object';

__PACKAGE__->attributes(qw/code uri name description inactive/);

use Dancer ':syntax';
use Dancer::Plugin::Nitesi;

sub init {
    my ($self, %args) = @_;
    my ($set, $nav_ref);

    # initialize our queries
    $self->_build_query_init(config->{navigation}->{main});
    
    if ($args{uri}) {
	# lookup uri from navigation table
	$set = query->select($self->_build_query_path($args{uri}));

	if (@$set == 1) {
	    # populate fields
	    $nav_ref = $set->[0];

	    for (keys %$nav_ref) {
		$self->{$_} = $nav_ref->{$_};
	    }
	}
    }
}

=head2 products

Returns list of products for this navigation entry.
    
=cut
    
sub products {
    my ($self) = @_;

    return query->select($self->_build_query_products);
}

sub _build_query_init {
    my ($self, $overrides) = @_;

    # defaults
    $self->{query_parameters} = {table => 'navigation',
				 uri_field => 'uri',
				 link_table => 'navigation_products',
				 link_field => 'navigation',
				 items_table => 'products',
				 items_link_field => 'sku',
	};

    # overrides
    for (keys %$overrides) {
	$self->{query_parameters}->{$_} = $overrides->{$_};
    }

    return 1;
}
    
sub _build_query_path {
    my ($self, $path) = @_;

    return (table => $self->{query_parameters}->{table},
	    where => {$self->{query_parameters}->{uri_field} => $path});
}

sub _build_query_products {
    my ($self) = @_;
    my ($products, $navigation_products, $navigation_link, $sku);

    $products = $self->{query_parameters}->{items_table};
    $navigation_products = $self->{query_parameters}->{link_table};
    $navigation_link = $self->{query_parameters}->{link_field};
    $sku = $self->{query_parameters}->{items_link_field};
    
    return (join => "$products $products.sku=$navigation_products.sku $navigation_products",
	    fields => ["$products.sku", "$products.name", "$products.description", "$products.price"],
	    where => {-not_bool => "$products.inactive",
		      "$navigation_products.$navigation_link" => $self->{code}},
	    order => "$products.priority");
}

1;
