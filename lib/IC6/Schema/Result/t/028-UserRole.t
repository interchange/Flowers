use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_user_role);

use_ok('IC6::Schema::Result::UserRole');

is('user_roles', IC6::Schema::Result::UserRole->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $user_role = make_user_role(), 'role row initialized');

                ok($user_role->insert, 'Insert worked');

                die "rollback";
            });

1;

