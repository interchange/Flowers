use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_merchandising_product);

use_ok('IC6::Schema::Result::MerchandisingProduct');
is('merchandising_products', IC6::Schema::Result::MerchandisingProduct->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $merchandising_product = make_merchandising_product(), 'merchandising_product row initialized');

                ok($merchandising_product->insert, 'Insert worked');

                die "rollback";
            });

1;
