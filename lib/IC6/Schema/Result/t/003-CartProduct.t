use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_cart_product);

use_ok('IC6::Schema::Result::CartProduct');
is('cart_products', IC6::Schema::Result::CartProduct->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $cart_product = make_cart_product(), 'cart_product row initialized');

                ok($cart_product->insert, 'Insert worked');

                die "rollback";
            });

1;
