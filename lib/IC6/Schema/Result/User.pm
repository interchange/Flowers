use utf8;
package IC6::Schema::Result::User;

use strict;
use warnings;

use DBIx::Class::Candy (
	  -components => [qw( EncodedColumn InflateColumn::DateTime Core )],
  );

############################################################################
# Table definition.

table 'users';

############################################################################
## Field definition.

primary_column users_id => {
  data_type			=>  'bigint',
  is_nullable		=> 0,
  is_auto_increment => 1,
  is_numeric        => 1,
  extra				=> {unsigned => 1},
};

column username	=> {
  data_type     => 'varchar',
  size          => 255,
  is_nullable   => 0,
};

column email => {
  data_type  => 'varchar',
  size       => 255,
  is_nullable => 0,
  default_value =>'',
};

column password => {
  data_type     => 'varchar',
  size          => 255,
  is_nullable   => 0,
  encode_column => 1,
  encode_class  => 'Digest',
  encode_args   => { algorithm => 'SHA-512', format => 'hex', salt_length => 10 },
  encode_check_method => 'check_password',
};

column first_name => {
  data_type       => 'varchar',
  size            => 255,
  is_nullable     => 0,
};

column last_name => {
  data_type      => 'varchar',
  size           => 255,
  is_nullable    => 0,
};

column last_name => {
  data_type      => 'datetime',
  datetime_undef_if_invalid => 1,
  is_nullable    => 0,
};

column created => {
  data_type    => 'datetime',
  datetime_undef_if_invalid => 1,
  is_nullable  => 0,
};

column modified => {
  data_type    => 'datetime',
  datetime_undef_if_invalid => 1,
  is_nullable  => 0,
};

column active => {
  data_type   => 'tinyint',
  default_value => 1,
  is_nullable  => 0,
};

#########################################################################
# Relation definition.

has_many addresses => 'IC6::Schema::Result::Address', {
  'foreign.users_id' => 'self.users_id',
  },  
  { cascade_copy => 0, cascade_delete => 0 };

has_many carts => 'IC6::Schema::Result::Cart', {
  'foreign.users_id' => 'self.users_id',
  },
  { cascade_copy => 0, cascade_delete => 0 };

has_many orders => 'IC6::Schema::Result::Order', {
  'foreign.users_id' => 'self.users_id',
  },
  { cascade_copy => 0, cascade_delete => 0 };

has_many user_attributes => 'IC6::Schema::Result::UserAttribute', {
  'foreign.users_id' => 'self.users_id',
  },
  { cascade_copy => 0, cascade_delete => 0 };

has_many user_roles => 'IC6::Schema::Result::UserRole', {
  'foreign.users_id' => 'self.users_id',
  },
  { cascade_copy => 0, cascade_delete => 0 };

many_to_many roles => 'userroles', 'role', { cascade_copy => 0, cascade_delete => 0 };
#########################################################################
1;
