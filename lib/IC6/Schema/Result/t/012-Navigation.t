use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_navigation);

use_ok('IC6::Schema::Result::Navigation');
is('navigation', IC6::Schema::Result::Navigation->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $navigation= make_navigation(), 'navigation row initialized');

                ok($navigation->insert, 'Insert worked');

                die "rollback";
            });

1;

