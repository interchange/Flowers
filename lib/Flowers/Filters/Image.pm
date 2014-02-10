package Flowers::Filters::Image;

use base 'Template::Flute::Filter::Currency';

sub filter {
    my ($self, $sku) = @_;

    return "img/$sku.jpg";
}

1;

