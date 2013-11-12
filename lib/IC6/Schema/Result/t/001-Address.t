use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_address);

use_ok('IC6::Schema::Result::Address');

is('addresses', IC6::Schema::Result::Address->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $address = make_address(), 'address row initialized');

                ok($address->insert, 'Insert worked');

                die "rollback";
            });

1;
