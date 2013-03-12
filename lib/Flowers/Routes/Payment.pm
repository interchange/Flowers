package Flowers::Routes::Payment;

use Dancer ':syntax';

get '/payment/success' => sub {
    debug("Body success: ", request->body);
    return 'SUCCESS';
};

get '/payment/error' => sub {
    debug("Body error: ", request->body);
    die 'ERROR';
};

1;

