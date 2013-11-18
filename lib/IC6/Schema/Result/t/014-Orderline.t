use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_orderline);

use_ok('IC6::Schema::Result::Orderline');
is('orderlines', IC6::Schema::Result::Orderline->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $orderline = make_orderline(), 'orderlines row initialized');

                ok($orderline->insert, 'Insert worked');

                die "rollback";
            });

1;
