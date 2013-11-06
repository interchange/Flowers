package Flowers::Products;

use strict;
use warnings;
use base 'Exporter';
use vars '@EXPORT_OK';

@EXPORT_OK = qw(product product_list);

use DBI;
use IC6::Schema;
use IC6::Schema::Result::Product;

our (@connection, $db);

BEGIN {
    @connection = ('dbi:mysql:database=ic6;host=localhost;mysql_socket=/home/jeff/camp13/mysql/tmp/mysql.13.sock','ic6','woc46mij');

    $db = IC6::Schema->connect(@connection);
}

sub product {
    my ($path) = @_;
    my ($result);

    # check whether product is available
    my $rs = $db->resultset('Product');
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    $result = $rs->search({ sku => $path, active => 1, })->next();
	return $result->{_column_data};
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

    $set = $db->resultset('Product')->search(undef, {
        order_by => $order,
    })->all();
    return $set;
}

1;
