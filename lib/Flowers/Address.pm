package Flowers::Address;

use Moo;

has uid => (
    is => 'rw',
);

has type => (
    is => 'rw',
);

has first_name => (
    is => 'rw',
);

has last_name => (
    is => 'rw',
);

has street_address => (
    is => 'rw',
);

has zip => (
    is => 'rw',
);

has city => (
    is => 'rw',
);

has phone => (
    is => 'rw',
);

has state_code => (
    is => 'rw',
);

has country_code => (
    is => 'rw',
);

1;
