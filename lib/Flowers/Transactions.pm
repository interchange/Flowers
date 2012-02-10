package Flowers::Transactions;

use Moo;

has order_date => (
    is => 'rw',
    lazy => 1,
    builder => '_order_date',
);

sub submit {
    my ($self) = @_;
    my (%transaction);

    # initialize order date
    $transaction{order_date} = $self->order_date;
}

sub _order_date {
    return DateTime->now->iso8601;
}

1;

