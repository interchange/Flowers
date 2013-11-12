use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_setting);

use_ok('IC6::Schema::Result::Setting');
is('settings', IC6::Schema::Result::Setting->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $setting= make_setting(), 'setting row initialized');

                ok($setting->insert, 'Insert worked');

                die "rollback";
            });

1;

