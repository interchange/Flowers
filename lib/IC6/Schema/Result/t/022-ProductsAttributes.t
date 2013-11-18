use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_products_attributes);

use_ok('IC6::Schema::Result::ProductAttributes');
is('products_attributes', IC6::Schema::Result::ProductAttributes->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $product_attribute = make_products_attributes(), 'products_attributes row initialized');

                ok($product_attribute->insert, 'Insert worked');

                die "rollback";
            });

1;

