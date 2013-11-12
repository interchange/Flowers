use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_merchandising_attribute);

use_ok('IC6::Schema::Result::MerchandisingAttribute');
is('merchandising_attributes', IC6::Schema::Result::MerchandisingAttribute->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $merchandising_attribute = make_merchandising_attribute(), 'merchandising_attribute row initialized');

                ok($merchandising_attribute->insert, 'Insert worked');

                die "rollback";
            });

1;
