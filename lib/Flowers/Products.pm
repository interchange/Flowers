package Flowers::Products;

use strict;
use warnings;
use base 'Exporter';
use vars '@EXPORT_OK';

@EXPORT_OK = qw(product product_list);

use Dancer::Plugin::Nitesi;

sub product {
    my ($path) = @_;
    my ($set);
    
    # check whether product is available
    $set = query->select(table => 'products', where => {sku => $path});

    if (@$set) {
	return $set->[0];
    }
}

=head2 product_list

Returns a list of all products, ordered by priority.
    
=cut
    
sub product_list {
    my (%args) = @_;
    my ($order, $set);

    $args{sort} ||= 'priority';
	
    if ($args{sort} eq 'price') {
	$order = 'price ASC, priority ASC';
    }
    else {
	$order = 'priority ASC';
    }
    
    $set = query->select(table => 'products', where => {}, order => $order);
    return $set;
}

1;
