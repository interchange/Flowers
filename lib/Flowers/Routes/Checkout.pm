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
    $ipayment->transactionType('preauth');
    $ipayment->trxCurrency('EUR');
    $ipayment->trxAmount(cart->total * 100);
    debug "Total trx:" . $ipayment->trxAmount;

    # get the params
    my %params = params();
    debug to_dumper(\%params);
    my %safe;
    # fill the form with the values bounced back from the remote server.
    # not all, but just the values set there.
    my $form = form('payment');
    $form->reset; # avoid stickiness
    foreach my $f (qw/addr_name
                      addr_street
                      addr_zip
                      addr_city
                      addr_telefon
                      addr_email/) {
        $safe{$f} = $params{$f}
    }

    # the relevant fields (building the session on the fly)
    $safe{ipayment_session_id} = $ipayment->session_id;
    $safe{trx_securityhash} = $ipayment->trx_securityhash;
    # set the cgi location without hardcoding it
    $form->action($ipayment->ipayment_cgi_location);

    $form->fill(\%safe);
    # also, pick the ret_errormsg from the server. We can't know
    # anything about that.
    return template 'checkout-payment',
      { form => $form,
        payment_error => $params{ret_errormsg}
      };
};

get '/checkout-success' => sub {
    my %params = params();
    debug to_dumper(\%params);
    # here we will do all the needed test and approve/save. It could
    # be also a hidden trigger.
    session->destroy; # maybe?
    return template 'checkout-thanks' => {};
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
    $ipayment = Business::OnlinePayment::IPayment->new(%$settings);
    # that's it :-)
}



true;
