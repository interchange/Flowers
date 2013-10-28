package Flowers::Routes::Account;

use Dancer ':syntax';
use Dancer::Plugin::Nitesi;
use Dancer::Plugin::Form;

use Input::Validator;

get '/registration' => sub {
    my $form;

    $form = form('registration');
    
    template 'registration', {form => $form,
			      layout_noleft => 1,
			      layout_noright => 1};
};

post '/registration' => sub {
    my ($form, $values, $validator, $error_ref, $acct);

    $form = form('registration');

    $values = $form->values;

    # validate form input
    $validator = new Input::Validator;

    $validator->field('email')->required(1)->email();
    $validator->field('password')->required(1);
    $validator->field('verify')->required(1);

    $validator->validate($values);

    if ($validator->has_errors) {
	$error_ref = $validator->errors;
	debug("Register errors: ", $error_ref);
	$form->errors($error_ref);
	$form->fill($values);
    }
    else {
	# create account
	debug("Register account: $values->{email}.");
	$acct = account->create(email => $values->{email},
				password => $values->{password});
	debug("Register result: ", $acct || 'N/A');
    }
    
    template 'registration', {form => $form,
			      errors => $error_ref,
			      layout_noleft => 1,
			      layout_noright => 1};
};

get '/login' => sub {
    template 'login', {layout_noleft => 1,
		       layout_noright => 1};
};

post '/login' => sub {
    my ($acct, $continue);

    $continue = account->status('login_continue') || '';
    
    if (account->login(username => params('body')->{email},
		       password => params('body')->{password})) {
	debug "Successful login for: ", params('body')->{email};

	return redirect "/$continue";
    }

    debug "Login failed for: ", params('body')->{email};
    
    account->status(login_info => 'Invalid username or password.');
    
    template 'login', {layout_noleft => 1,
		       layout_noright => 1};
};

1;
