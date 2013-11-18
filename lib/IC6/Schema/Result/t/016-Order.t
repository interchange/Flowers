use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_order);

use_ok('IC6::Schema::Result::Order');
is('orders', IC6::Schema::Result::Order->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $order = make_order(), 'orders row initialized');

                ok($order->insert, 'Insert worked');

                die "rollback";
            });

1;
