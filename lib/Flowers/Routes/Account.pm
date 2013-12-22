package Flowers::Routes::Account;

use Dancer ':syntax';
use Dancer::Plugin::Interchange6;
use Dancer::Plugin::Form;
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Auth::Extensible qw(
logged_in_user authenticate_user user_has_role require_role
require_login require_any_role
);

use Input::Validator;
use DateTime qw();
use DateTime::Duration qw();

my $now = DateTime->now;

# add default admin user for testing
#my $admin_user =
#        rset('User')
#        ->create(
#        { username => 'admin', password => 'admin', email => 'admin@localhost', created => $now } );

get '/registration' => sub {
    template 'registration', {layout_noleft => 1,
        layout_noright => 1};
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
    #debug("Register account: $values->{email}.");
    $acct = rset('User')->create( $user_data );
   
    # add role
    $role = rset('UserRole')->create( { users_id => $acct->id, roles_id => $user_role_id  } );

    #debug("Register result: ", $acct || 'N/A');
    return redirect '/login';
    }

    template 'registration', {form => $form,
                  errors => $error_ref,
                  layout_noleft => 1,
                  layout_noright => 1};

};

sub post_login_route {
   return redirect '/' if logged_in_user;

   my $login_route = '/login';

   my $user = rset('User')->find( { username => params->{username} } );
   if ( !$user ) {
        var login_failed => 1;
        return forward $login_route, { return_url => params->{return_url} }, { method => 'get' };
  }
    my ($success, $realm) = authenticate_user( params->{username}, params->{password} );

    if ($success) {
        session logged_in_user => $user->username;
        session logged_in_user_id => $user->id;
        session logged_in_user_realm => $realm;
        return redirect '/';
    } else {
    #something
}
};

post '/login' => \&post_login_route;

get '/logout' => sub {
    template 'login', {layout_noleft => 1,
        layout_noright => 1};
    session->destroy;
    return redirect '/';
};

1;
