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

Returns a list of all products, ordered by name.
    
=cut
    
sub product_list {
    my ($set);
    
    $set = query->select(table => 'products', where => {});
    return $set;
}

1;
