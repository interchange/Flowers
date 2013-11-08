use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_media_type);

use_ok('IC6::Schema::Result::MediaType');
is('media_types', IC6::Schema::Result::MediaType->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $media_type = make_media_type(), 'media_type row initialized');

                ok($media_type->insert, 'Insert worked');

                die "rollback";
            });

1;
