use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use IC6::Schema;
use IC6::Schema::TestBed qw($db make_media_display);

use_ok('IC6::Schema::Result::MediaDisplay');
is('media_displays', IC6::Schema::Result::MediaDisplay->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $media_display = make_media_display(), 'media_display row initialized');

                ok($media_display->insert, 'Insert worked');

                die "rollback";
            });

1;
