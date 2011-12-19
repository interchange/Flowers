package Flowers::Routes::Checkout;

use Dancer ':syntax';
use Dancer::Plugin::Nitesi;
use Dancer::Plugin::Form;

use Input::Validator;
use Business::OnlinePayment;

get '/checkout' => sub {
    my $form;

    $form = form('giftinfo');
	
    template 'checkout-giftinfo', {form => $form};
};

post '/checkout' => sub {
    my ($form, $values, $validator, $error_ref, $form_last);

    $form_last = 'giftinfo';
    
    for my $name (qw/payment giftinfo/) {
	$form = form($name);

	if (@{$form->fields}) {
	    $form_last = $name;
	    last;
	}
    }

    debug("Form last: $form_last.");
    
    if ($form_last eq 'giftinfo') {
	$values = $form->values;

	# validate form input
	$validator = new Input::Validator;

	$validator->field('first_name')->required(1);
	$validator->field('last_name')->required(1);

	$validator->validate($values);

	if ($validator->has_errors) {
	    $error_ref = $validator->errors;
	    debug("Errors: ", $error_ref);
	
	    # back to first step
	    $form->fill($values);
	    template 'checkout-giftinfo', {form => $form, errors => $error_ref};
	}
	else {
	    $form = form('payment');
	    template 'checkout-payment', {form => $form};
	}
    }
    elsif ($form_last eq 'payment') {
	# second step
	$values = $form->values();
	
	# validate form input
	$validator = new Input::Validator;

	$validator->field('name')->required(1);
	$validator->field('street_address')->required(1);
	$validator->field('zip')->required(1);
	$validator->field('city')->required(1);
	
	$validator->validate($values);

	if ($validator->has_errors) {
	    $error_ref = $validator->errors;
	    debug("Errors: ", $error_ref);

	    # back to second step
	    $form->fill($values);
	    template 'checkout-payment', {form => $form, errors => $error_ref};
	}
	else {
	    # charge amount
	    my $tx;
	    
	    $tx = charge(amount => cart->total);

	    if ($tx->is_success()) {
		debug("Payment redirect: ", $tx->popup_url());
		
		return redirect $tx->popup_url();
		    
		template 'checkout-thanks';
	    }
	    else {
		template 'checkout-payment', {form => $form, errors => $error_ref};
	    }
	}
    }
};

sub charge {
    my (%args) = @_;
    my ($tx, $settings);

    $settings = config->{payment};
    
    $tx = Business::OnlinePayment->new('ACI', context => $settings->{context},
				       response_url => $settings->{response_url},
				       error_url => $settings->{error_url},
	);
				       
    $tx->server($settings->{server});
    
    $tx->content(amount => $args{amount},
		 login => $settings->{login},
		 password => $settings->{password}
	);

    $tx->submit();

    if ($tx->is_success()) {
	debug("Success!  Redirect browser to ". $tx->popup_url());
    } else {
        debug("Card was rejected: " . $tx->error_message);
    }

    return $tx;
}

true;
