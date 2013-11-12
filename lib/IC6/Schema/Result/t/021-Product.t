use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_product);

use_ok('IC6::Schema::Result::Product');
is('products', IC6::Schema::Result::Product->table(), 'Table is defined correctly');


$db->txn_do(sub {
                ok(my $product = make_product(), 'product row initialized');

                ok($product->insert, 'Insert worked');

                die "rollback";
            });

1;
