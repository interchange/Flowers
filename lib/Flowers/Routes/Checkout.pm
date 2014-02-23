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

            my $users_id = session('logged_in_user_id');

            # create payment order
            
            my ($addr_form, $ship_address, $bill_address, $addr_values);
		
            # create delivery address from gift info form
            $addr_form = form('giftinfo');
            $addr_values = $addr_form->values('session');
            $addr_values->{users_id} = $users_id;
            $addr_values->{country_iso_code} = delete $addr_values->{country};
            $addr_values->{address} = delete $addr_values->{street_address};
            $addr_values->{postal_code} = delete $addr_values->{zip};
            $addr_values->{type} = 'shipping';

            for my $name (qw/time gender message day month time/) {
                delete $addr_values->{$name};
            }

            debug("Delivery address values: ", $addr_values);

            $ship_address = shop_address->create($addr_values);

            # create billing address from payment form
            $addr_form = form('payment');
            $addr_values = $addr_form->values;
            $addr_values->{users_id} = $users_id;
            $addr_values->{country_iso_code} = 'SI';
            $addr_values->{address} = delete $addr_values->{street_address};
            $addr_values->{postal_code} = delete $addr_values->{zip};
            $addr_values->{type} = 'billing';

            for my $name (qw/gender cc_number cvc_number cc_month cc_year email/) {
                delete $addr_values->{$name};
            }

            debug("Billing address values: ", $addr_values);

            $bill_address = shop_address->create($addr_values);

            # order date
            my $order_date = DateTime->now->iso8601;
            
            # create orderlines
            my @orderlines;
            my $position = 1;
            my $cart_items = cart->items;

            for my $item (@$cart_items) {
                debug "Items: ", $item;
                my $ol_prod = shop_product($item->{sku});
                my %orderline_product = (
                    sku => $ol_prod->sku,
                    order_position => $position++,
                    name => $ol_prod->name,
                    short_description => $ol_prod->short_description,
                    description => $ol_prod->description,
                    weight => $ol_prod->weight,
                    quantity => $item->{quantity},
                    price => $ol_prod->price,
                    subtotal => $ol_prod->price * $item->{quantity},
                );

                push @orderlines, \%orderline_product;
            }

            # create transaction
            my %order_info = (users_id => session('logged_in_user_id'),
                              billing_addresses_id => $bill_address->id,
                              shipping_addresses_id => $ship_address->id,
                              order_date => $order_date,
                              order_number => $order_date,
                              Orderline => \@orderlines);

            shop_order->create(\%order_info);

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

    my %form_values;

    if (session('logged_in_user')) {
        my ($address_list, $address, $address_type);

        if ($form->name eq 'payment') {
            $address_type = 'billing';
        }
        else {
            $address_type = 'shipping';
        }

        $address_list = shop_address->search({users_id => session('logged_in_user_id'), type => $address_type});

        if ($address = $address_list->next) {
            %form_values = (
                first_name => $address->first_name,
                last_name => $address->last_name,
                street_address => $address->address,
                zip => $address->postal_code,
                city => $address->city,
                country => $address->country_iso_code,
                phone => $address->phone,
                email => session('logged_in_user'),
            );
        }
    }

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

    if (config->{environment} eq 'development') {
        $form_values{cc_number} = '4111 1111 1111 1111';
        $form_values{cvc_number} = '111';
        $form_values{cc_month} = '12';
        $form_values{cc_year} = '18';
    }

    $form->fill(\%form_values);

    if ($errors) {
        $tokens->{errors} = $errors;
        $tokens->{payment_error} = delete $errors->{payment_error};
    }

    return $tokens;
}

true;
