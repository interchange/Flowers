package Flowers::Routes::Checkout;

use Dancer ':syntax';
use Dancer::Plugin::Nitesi;
use Dancer::Plugin::Form;

use DateTime;
use DateTime::Duration;
use DateTime::Locale;
use Input::Validator;
use Business::OnlinePayment;

get '/checkout' => sub {
    my $form;

    $form = form('giftinfo');
    $form->valid(0);
    
    template 'checkout-giftinfo', checkout_tokens($form);
};

post '/checkout' => sub {
    my ($form, $values, $validator, $error_ref, $form_last);

    $form_last = 'giftinfo';
    
    for my $name (qw/giftinfo payment/) {
	$form = form($name);

	unless ($form->valid) {
	    $form_last = $name;
	    last;
	}
    }
    
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
	    $form->errors($error_ref);
	    
	    # back to first step
	    $form->fill($values);
	    template 'checkout-giftinfo', checkout_tokens($form, $error_ref);
	}
	else {
	    $form->valid(1);

	    $form = form('payment');
	    template 'checkout-payment', checkout_tokens($form);
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
	    template 'checkout-payment', checkout_tokens($form, $error_ref);
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
		template 'checkout-payment', {form => $form,
					      layout_noleft => 1,
					      layout_cartright => 1,
					      errors => $error_ref};
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

sub checkout_tokens {
    my ($form, $errors) = @_;
    my ($tokens, $dtl, $cur_date, $duration, $i, @months, @years, $day, @gift_days);

    $dtl = DateTime::Locale->load(config->{locale});
    $cur_date = DateTime->now(locale => $dtl);
    $duration = DateTime::Duration->new(days => 1);
    
    # gift info
    for (my $i = 0; $i < 60; $i++) {
	$day = $cur_date->day;
	
	push (@gift_days, {value => $day, label => ucfirst($cur_date->day_abbr) . ", $day"});

	$cur_date->add_duration($duration);
    }
    
    # month/years for CC checkout
    $i = 1;
    for my $name (@{$dtl->month_stand_alone_abbreviated}) {
	push (@months, {value => $i++, label => ucfirst($name)});
    }

    for my $year (2012 .. 2020) {
	push (@years, {value => substr($year,2,2), label => $year});
    }
    
    $tokens = {form => $form,
	       errors => $errors,
	       layout_noleft => 1,
	       layout_cartright => 1,
	       items => cart->items,
	       days => \@gift_days,
	       months => \@months,
	       years => \@years,
    };

    return $tokens;
}

true;
