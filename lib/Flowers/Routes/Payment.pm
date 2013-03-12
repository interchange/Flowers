package Flowers::Routes::Payment;

use Dancer ':syntax';

get '/payment/success' => sub {
    my %params = params();
    debug to_dumper(\%params);
    # and we get these parameters on success:
    # ret_transtime' => '17:19:16',
    # 'ret_errorcode' => '0',
    # 'redirect_needed' => '0',
    # 'ret_transdate' => '12.03.13',
    # 'addr_name' => 'Marco Rossi',
    # 'trx_paymentmethod' => 'VisaCard',
    # 'ret_authcode' => '',
    # 'trx_currency' => 'EUR',
    # 'form_submit' => 'Process payment',
    # 'ret_ip' => '93.137.207.56',
    # 'trx_typ' => 'auth',
    # 'ret_trx_number' => '1-83375660',
    # 'ret_status' => 'SUCCESS',
    # 'trx_paymenttyp' => 'cc',
    # 'trx_paymentdata_country' => 'US',
    # 'trx_amount' => '5000',
    # 'ret_booknr' => '1-83375660',
    # 'trxuser_id' => '99999',
    # 'trx_remoteip_country' => 'HR'

    # so here we can do our checking and then redirect somewhere else

    return 'SUCCESS';
};

get '/payment/error' => sub {
    my %params = params();
    debug to_dumper(\%params);

    # when we receive this, we pick the errors and return to the
    # checkout form, setting the errormessage.
    # Testing CC which doesn't generate an error
    # http://www.paypalobjects.com/en_US/vhelp/paypalmanager_help/credit_card_numbers.htm

    # collected errors

    #  'ret_additionalmsg' => 'The Creditcard-Number is invalid (0)',
    #  'ret_additionalmsg' => 'The Expdate (0113) is invalid',
    #  'ret_additionalmsg' => 'The Creditcard-Number has invalid length',
    #  'ret_additionalmsg' => 'No other characters than numbers are allowed in amount-field. The Amount needs to be set in the smallest currency-unit (e.g. cent).',
    #  'ret_additionalmsg' => 'CVV2-Code for Cardtyp 2 invalid',

    #  'trx_typ' => 'auth',
    #  'ret_errorcode' => '5002',
    #  'ret_status' => 'ERROR',
    #  'redirect_needed' => '0',
    #  'ret_errormsg' => 'Die angegebene Kreditkartennummer ist fehlerhaft.',
    #  'ret_additionalmsg' => 'The Creditcard-Number has invalid length',
    #  'trx_paymenttyp' => 'cc',
    #  'addr_name' => 'asdf',
    #  'trx_amount' => '50.00',
    #  'trxuser_id' => '99999',
    #  'trx_currency' => 'EUR',
    #  'form_submit' => 'Process payment',
    #  'ret_ip' => '93.137.207.56',
    #  'ret_fatalerror' => '0'
    # 
    # failure, redirect to the form, for example
    return redirect '/ipayment';
};

get '/ipayment' => sub {
    template 'checkout-ipayment'
};

1;

