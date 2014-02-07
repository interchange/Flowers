package Flowers::Routes::Account;

use Dancer ':syntax';
use Dancer::Plugin::Interchange6;
use Dancer::Plugin::Form;
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Auth::Extensible qw(
logged_in_user authenticate_user user_has_role require_role
require_login require_any_role
);

use Data::Transpose::Validator;
use DateTime qw();
use DateTime::Duration qw();

my $now = DateTime->now;

# add default admin user for testing
#my $admin_user =
#        rset('User')
#        ->create(
#        { username => 'admin', password => 'admin', email => 'admin@localhost', created => $now } );

get '/registration' => sub {
    my $form = form('registration');

    template 'registration', {layout_noleft => 1,
        layout_noright => 1,
        form => $form};
};

post '/registration' => sub {
    my ($form, $values, $validator, $error_ref, $acct, $user, $role, $user_data, $user_role_id );

    $form = form('registration');

    $values = $form->values;
    # id of user role
    $user_role_id = '3'; 
    $user_data = { username => $values->{email},
                      email    => $values->{email},
                      password => $values->{password},
                      created => $now
        };

    # validate form input
    $validator = Data::Transpose::Validator->new(requireall => 1);
    $validator->field('email' => "EmailValid");
    $validator->field('password' => 'PasswordPolicy');
    $validator->field('password')->username($values->{email});
    $validator->field('verify' => "String");
    $validator->group(passwords => ("verify", "password"));

    my $clean = $validator->transpose($values);
    my $errors;
    my $error_string;

    if (!$clean || $validator->errors) {
        $errors = $validator->errors_hash;
        $form->fill($values);
    }
    else {
    # create account
    #debug("Register account: $values->{email}.");
    $acct = rset('User')->create( $user_data );
   
    # add role
    $role = rset('UserRole')->create( { users_id => $acct->id, roles_id => $user_role_id  } );

    #debug("Register result: ", $acct || 'N/A');
    return redirect '/login';
    }

    template 'registration', {form => $form,
                  errors => $errors,
                  layout_noleft => 1,
                  layout_noright => 1};

};

1;
