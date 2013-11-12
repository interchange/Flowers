use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_role);

use_ok('IC6::Schema::Result::Role');
is('roles', IC6::Schema::Result::Role->table(), 'Table is defined correctly');


$db->txn_do(sub {
                ok(my $role = make_role(), 'role row initialized');

                ok($role->insert, 'Insert worked');

                die "rollback";
            });

1;
