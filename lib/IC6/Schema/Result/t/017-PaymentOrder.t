use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_payment_order);

use_ok('IC6::Schema::Result::PaymentOrder');
is('payment_orders', IC6::Schema::Result::PaymentOrder->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $payment_order = make_payment_order(), 'payment_orders row initialized');

                ok($payment_order->insert, 'Insert worked');

                die "rollback";
            });

1;
