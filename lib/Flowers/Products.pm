package Flowers::Products;

use strict;
use warnings;
use base 'Exporter';
use vars '@EXPORT_OK';

@EXPORT_OK = qw(product);

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

1;
