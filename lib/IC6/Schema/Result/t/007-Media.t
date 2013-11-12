use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_media);

use_ok('IC6::Schema::Result::Media');
is('media', IC6::Schema::Result::Media->table(), 'Table is defined correctly');

eval {
    $db->txn_do(sub {
                    ok(my $attr = make_media(), 'media row initialized');

                    ok($attr->insert, 'Insert worked');

                    die "rollback";
                });
    1;
};

1;
