use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_permission);

use_ok('IC6::Schema::Result::Permission');
is('permissions', IC6::Schema::Result::Permission->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $permission = make_permission(), 'Permission row initialized');

                ok($permission->insert, 'Insert worked');

});

