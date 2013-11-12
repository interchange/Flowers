use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_product_attribute);

use_ok('IC6::Schema::Result::ProductAttribute');

is('product_attributes', IC6::Schema::Result::ProductAttribute->table(), 'Table is defined correctly');
eval {
    $db->txn_do(sub {
                    ok(my $attr = make_product_attribute(), 'product attribute row initialized');

                    ok($attr->insert, 'Insert worked');

                    die "rollback";
                });
    1;
};
