package Flowers::Address;

use Dancer::Plugin::Interchange6;
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

sub save {
    my $self = shift;
    my %data;

    %data = (uid => $self->uid || 0,
	     type => $self->type,
	     state_code => $self->state_code,
	     first_name => $self->first_name,
	     last_name => $self->last_name,
	     street_address => $self->street_address,
	     zip => $self->zip,
	     city => $self->city,
	     phone => $self->phone || '',
	     country_code => $self->country_code,
	     state_code => $self->state_code || '',
	);

    query->insert('addresses', \%data);
}

1;
