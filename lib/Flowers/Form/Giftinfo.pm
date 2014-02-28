package Flowers::Form::Giftinfo;

use strict;
use warnings;

use Moo;
use Data::Transpose;

has address => (
    is => 'ro',
    required => 1,
);

sub transpose {
    my ($self) = @_;
    my $tp = Data::Transpose->new;

    $tp->field('first_name');
    $tp->field('last_name');
    $tp->field('address')->target('street_address');
    $tp->field('postal_code')->target('zip');
    $tp->field('city');
    $tp->field('phone');
    $tp->field('country_iso_code')->target('country');

    my $form_values = $tp->transpose_object($self->address);

    return $form_values;
}

1;
