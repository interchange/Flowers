package Flowers::Routes::Account;

use Dancer ':syntax';
use Dancer::Plugin::Nitesi;

get '/registration' => sub {
    template 'registration';
};

1;
