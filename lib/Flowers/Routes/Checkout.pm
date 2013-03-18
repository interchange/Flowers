package Flowers::Routes::Checkout;

use Dancer ':syntax';
use Dancer::Plugin::Nitesi;
use Dancer::Plugin::Form;

use DateTime;
use DateTime::Duration;
use DateTime::Locale;
use Input::Validator;
use Business::OnlinePayment::IPayment;

use Flowers::Address;
use Flowers::Transactions;


my $ipayment;



get '/checkout' => sub {
    my $form;
    my $shopper_id = int(rand(999999));
    # assign a cart id: this is not working
    # cart->id($shopper_id);
    # debug "Assigned cart id:" . cart->id;
    # so put it in the session
    session 'ipayment_shopper_id' => $shopper_id;
    $form = form('giftinfo');
    $form->valid(0);
    template 'checkout-giftinfo', checkout_tokens($form);
};

get '/checkout-payment' => sub {
    unless (defined $ipayment) {
        $ipayment = _init_ipayment();
    }
    # hardcoded, because the amout must be multiplied by 100. Crazy and scary
    debug "Total in EUR:" . cart->total;
    my $total = cart->total * 100;
    my $shopperid = cart->id || session->{ipayment_shopper_id};

    $ipayment->transaction(transactionType => 'preauth',
                           trxCurrency     => 'EUR',
                           trxAmount       => $total,
                           shopper_id      => $shopperid);
    debug "Total trx:" . $ipayment->trx_obj->trxAmount;
    unless ($ipayment->trx_obj->shopper_id and
            $ipayment->trx_obj->trxAmount) {
        # in case the session is broken, we can't proceed.
        return redirect '/';
    };
    # validate the parameters
    my %params = params();
    my %safe;
    my $form = form('payment');
    $form->reset;       # avoid stickiness

    if (%params) {
        my $uri = request->uri_base . request->request_uri;
        debug "Checking params for $uri";
        debug to_dumper(\%params);
        my $resp = $ipayment->get_response_obj($uri);
        if ($resp->url_is_valid) {
            # fill the form with the values bounced back from the remote server.
            # not all, but just the values set there.
            foreach my $f (qw/addr_name
                              addr_street
                              addr_zip
                              addr_city
                              addr_telefon
                              addr_email/) {
                $safe{$f} = $params{$f}
            }
        }
        else {
            warning "Paramaters look tampered";
            return redirect '/';
        }
    }
            # the relevant fields (building the session on the fly)
    $safe{ipayment_session_id} = $ipayment->session_id;
    debug to_dumper($ipayment->debug->request->content);
    $safe{trx_securityhash}    = $ipayment->trx_securityhash;

    debug \%safe;
    unless ($safe{ipayment_session_id} and 
            $safe{trx_securityhash}) {
        warning "Cannot generate a session";
        # what should we do here? We can't do the payment. So redirect
        # to /
        return redirect '/';
    }
    # set the cgi location without hardcoding it
    $form->action($ipayment->ipayment_cgi_location);

    $form->fill(\%safe);
    # also, pick the ret_errormsg from the server. We can't know
    # anything about that.
    return template 'checkout-payment',
      { form => $form,
        # bounce the error from the remote server into the form
        payment_error => $params{ret_errormsg}
      };
};

get '/checkout-success' => sub {
    my %params = params();
    # debug to_dumper(\%params);
    my $resp = Business::OnlinePayment::IPayment::Response->new(%params);
    my $amount = cart->total * 100;
    warning "Charging $amount";
    my %ipacc = (
                 my_amount => $amount,
                 my_currency => "EUR", # cart doesn't seem to provide
                 my_userid => config->{payment_method}->{trxuserId},
                 my_security_key => config->{payment_method}->{app_security_key}
                 );
    $resp->set_credentials(%ipacc);
    my $uri = request->uri_base . request->request_uri;
    unless ($resp->url_is_valid($uri)) {
        warning "The parameters look tampered!:" . $resp->validation_errors;
        status 400;
        return "There are problems with your order: this issue has been reported"
    }
    if ($resp->is_success and $resp->is_valid) {
        # debug "Clearing the cart" . cart->id;
        my $shopper_id = cart->id || session->{ipayment_shopper_id};
        if ($resp->shopper_id eq $shopper_id) {
            # here the data should be saved, with the $resp->ret_authcode
            # et. alii or simply dumping %params to yaml, as it has been
            # double checked (urls untampered, params matching"
            info to_yaml(\%params);
            cart->clear;
            return template 'checkout-thanks';
        } else {
            warning "Cart id and shopper id don't match!" . cart->id . " and " .
              $resp->shopper_id;
        }
    }
    warning $resp->validation_errors;
    # mail out the %params
    return "There are problems with your order. This issue has been reported"
};

post '/hidden-trigger' => sub {
    my %params = params();
    my $host = request->remote_address;
    debug "Processing post coming from $host";
    if ($host eq '212.227.34.218' or
        $host eq '212.227.34.219' or
        $host eq '212.227.34.220') {

        info "Got the response from the server!";
        info to_yaml(\%params);

        # here we check again, but missing the details of the order, we can 
        # only check the checksum.

        my $resp = Business::OnlinePayment::IPayment::Response->new(%params);
        $resp->set_credentials(my_userid => config->{payment_method}->{trxuserId},
                               my_security_key => config->{payment_method}->{app_security_key});

        info "Response is success?" . $resp->is_success;
        info "Response is valid?"   . $resp->is_valid;
    } else {
        debug "Ignoring bogus host $host\n"
    }
};

post '/checkout' => sub {
    my ($form, $values, $validator, $error_ref, $form_last);

    $form = form('giftinfo');
    
    # sorry for the indentation off, but I want a clean patch

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
            # here we have to do the soap request creating the session
            # then we intercept the client on another route and
            # display checkout-thanks, destroying the session, maybe,
            # or at least clearing the cart
            debug cart->total;
            # to avoid confusion with actions not set and alike, we
            # redirect to the second step, where it's bounced by the
            # ipayment server in case of error.
            return redirect '/checkout-payment';
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
    debug("Months: ", \@months);

    for my $year (2012 .. 2020) {
	push (@years, {value => substr($year,2,2), label => $year});
    }
    
    %$tokens = (form => $form,
	       layout_noleft => 1,
	       layout_cartright => 1,
	       items => cart->items,
	       days => \@gift_days,
	       months => \@months,
	       years => \@years,
    );

    if ($errors) {
        $tokens->{errors} = $errors;
        $tokens->{payment_error} = delete $errors->{payment_error};
    }

    return $tokens;
}

=head2 _init_ipayment

Initialize the ipayment persistent object if it's not initialized.
This operation takes some time, so we want to reuse it. We do this at
run time to avoid troubles with forks, conf not loaded yet, etc.

=cut

sub _init_ipayment {
    my $settings = config->{payment_method};
    debug to_dumper($settings);
    return Business::OnlinePayment::IPayment->new(%$settings);
    # that's it :-)
}



true;
