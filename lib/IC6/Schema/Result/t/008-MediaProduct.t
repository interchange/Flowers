use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_media_product);

use_ok('IC6::Schema::Result::MediaProduct');
is('media_products', IC6::Schema::Result::MediaProduct->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $media_product = make_media_product(), 'media_product row initialized');

                ok($media_product->insert, 'Insert worked');

                die "rollback";
            });

1;
