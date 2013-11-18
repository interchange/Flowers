use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_cart);

use_ok('IC6::Schema::Result::Cart');
is('carts', IC6::Schema::Result::Cart->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $cart = make_cart(), 'cart row initialized');

                ok($cart->insert, 'Insert worked');

                die "rollback";
            });

1;
