use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_group_pricing);

use_ok('IC6::Schema::Result::GroupPricing');
is('group_pricing', IC6::Schema::Result::GroupPricing->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $group_pricing = make_group_pricing(), 'group_pricing row initialized');

                ok($group_pricing->insert, 'Insert worked');

                die "rollback";
            });

1;
