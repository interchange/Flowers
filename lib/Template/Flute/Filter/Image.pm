package Template::Flute::Filter::Image;

use strict;
use warnings;

use base 'Template::Flute::Filter';

=head1 NAME

Template::Flute::Filter::Image

=head1 DESCRIPTION

Image filter.

=head1 METHODS

=head2 filter

=cut

sub filter {
    my ($self, $sku) = @_;

    return "img/$sku.jpg";
}

1;

