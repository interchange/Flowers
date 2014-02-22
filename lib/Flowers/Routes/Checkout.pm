package Flowers::Routes::Checkout;

use Dancer ':syntax';
use Dancer::Plugin::Interchange6;
use Dancer::Plugin::Form;

use DateTime;
use DateTime::Duration;
use DateTime::Locale;
use Input::Validator;

use Flowers::Address;

hook 'before_cart_display' => sub {
    my $tokens = shift;
    my $form = form('giftinfo');

    $form->valid(0);

    template 'checkout-giftinfo', checkout_tokens($form, {}, $tokens);
};

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
	$validator->field('street_address')->required(1);
	$validator->field('zip')->required(1);
	$validator->field('city')->required(1);
	
	$validator->validate($values);

	if ($validator->has_errors) {
	    $error_ref = $validator->errors;
	    if ($error_ref->{zip}) {
		$error_ref->{zip_city} = $error_ref->{zip};
	    } elsif ($error_ref->{city}) {
		$error_ref->{zip_city} = $error_ref->{city};
	    }
		
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

    $validator->field('first_name')->required(1);
    $validator->field('last_name')->required(1);
	$validator->field('street_address')->required(1);
	$validator->field('zip')->required(1);
	$validator->field('city')->required(1);

    # credit card stuff
    $validator->field('cc_number')->required(1);
    $validator->field('cvc_number')->required(1);
    
	$validator->validate($values);

	if ($validator->has_errors) {
	    $error_ref = $validator->errors;

        if (exists $error_ref->{zip}
            || exists $error_ref->{city}) {
            $error_ref->{zip_city} = $error_ref->{zip} || $error_ref->{city};
	    }

	    debug("Errors: ", $error_ref);

	    # back to second step
	    $form->fill($values);
	    template 'checkout-payment', checkout_tokens($form, $error_ref);
	}
	else {
	    # charge amount
	    my ($expiration, $tx);

	    $expiration = sprintf("%02d%02d", $values->{cc_month}, $values->{cc_year});
	    my %payment_data = (amount => cart->total,
                     first_name => 'Test',
                     last_name => 'Tester',
                     card_number => $values->{cc_number},
                     expiration => $expiration,
                     cvc => $values->{cvc_number});

        debug("Payment_data: ", \%payment_data);
        
	    $tx = shop_charge(%payment_data);

        if ($tx->is_success()) {
            if ($tx->can('popup_url')) {
                debug("Payment redirect: ", $tx->popup_url());
		
                return redirect $tx->popup_url();
            }

            debug "Payment successful: ", $tx->authorization;

            my ($addr_form, $addr_values, $addr_ship, $addr_bill, $tx_order);
		
            # create delivery address from gift info form
            debug("Looking at giftinfo form.");
            $addr_form = form('giftinfo');
            $addr_values = $addr_form->values('session');
            $addr_values->{country_code} = 'SI';
            $addr_values->{type} = 'shipping';
            debug("Delivery address values: ", $addr_values);

            $addr_ship = Flowers::Address->new(%$addr_values);
            $addr_ship->save;

            # create billing address from payment form
		
            # create transaction
            $tx_order = Flowers::Transactions->new();
            $tx_order->submit;

            cart->clear;

            template 'checkout-thanks', checkout_tokens($form);
        }
	    else {
            $error_ref->{payment_error} = $tx->error_message;
            template 'checkout-payment', checkout_tokens($form, $error_ref);
	    }
	}
}
};

sub checkout_tokens {
    my ($form, $errors, $tokens) = @_;
    my ($dtl, $cur_date, $duration, $i, @months, @years, $day, @gift_days);

    $tokens ||= {};

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

    $tokens->{form} = $form;
    $tokens->{layout_noleft} = 1;
    $tokens->{layout_noright} = 1;
    $tokens->{layout_cartright} = 1;
    $tokens->{items} = cart->items;
    $tokens->{days} = \@gift_days;
    $tokens->{months} = \@months;
    $tokens->{years} = \@years;
    $tokens->{countries} = [shop_country->search({active => 1})];

    if ($errors) {
        $tokens->{errors} = $errors;
        $tokens->{payment_error} = delete $errors->{payment_error};
    }

    return $tokens;
}

true;
