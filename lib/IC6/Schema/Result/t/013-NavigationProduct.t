use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_navigation_product);

use_ok('IC6::Schema::Result::NavigationProduct');
is('navigation_products', IC6::Schema::Result::NavigationProduct->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $navigation_product = make_navigation_product(), 'navigation_product row initialized');

                ok($navigation_product->insert, 'Insert worked');

                die "rollback";
            });

1;
