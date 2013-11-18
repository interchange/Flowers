use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_user);

use_ok('IC6::Schema::Result::User');
is('users', IC6::Schema::Result::User->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $user = make_user(), 'User row initialized');

                ok($user->insert, 'Insert worked');

});

1;
