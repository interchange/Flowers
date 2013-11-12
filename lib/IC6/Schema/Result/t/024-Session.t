use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_session);

use_ok('IC6::Schema::Result::Session');
is('sessions', IC6::Schema::Result::Session->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $session= make_session(), 'session row initialized');

                ok($session->insert, 'Insert worked');

                die "rollback";
            });

1;

