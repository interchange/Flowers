package Flowers::Data::DataGen;

use strict;
use warnings;

use Interchange6::Schema;
use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;

use Dancer ':script';
use Dancer::Plugin::Interchange6;

#Random data generators
use Faker;
use Data::Generate qw{parse};

use utf8;

my $fake = Faker::Factory->new(locale => 'en_US')->create;
my $shop_schema = shop_schema;

sub roles{
	my $roles = [
			['anonymous', 'Anonymous Users'],
			['authenticated', 'Authenticated Users'],
			['user', 'User'],
			['admin', 'Admin'],
			['editor', 'Editor']
		];
	return $roles;
}

sub users{
	my $users = [{user_data =>{username => 'racke@linuxia.de',
				email => 'racke@linuxia.de',
				password => 'nevairbe',
				},
				address_data =>[{type => 'shipping',
							first_name => 'Test',
							last_name => 'Tester',
							address => 'Test Road 11',
							postal_code => '33333',
							city => 'Testhausen',
							country_iso_code => 'DE',
							phone => '111111',
							},
							{type => 'billing',
							first_name => 'Testa',
							last_name => 'Testerin',
							address => 'Test Ave 11',
							postal_code => '44444',
							city => 'Test City',
							country_iso_code => 'CA',
							phone => '111222',
							}
						]},
				{user_data =>{username => 'racke@nite.si',
				email => 'racke@nite.si',
				password => 'nevairbe',
				}	
			}];
	return $users; 
};


sub products{
	my $sku = shift;
	#generate product parents
	my ($name, $uri,  $short_description, $description) = data($sku);
	my $product = {sku => $sku,
		name => $name,
		short_description => $short_description,
		description =>  $description,
		price => price(),
		uri => $uri,
		canonical_sku => undef,
		weight => weight()
	};
	return $product;
}
#generate product variants
sub variants{
	my ($product, $no_colors) = @_;
	my $max_children_no = $no_colors || rand_int(0, $#{colors()}-1);
	my @variants;
	my $colors = unique_colors($max_children_no);
	foreach (@{$colors}){
		my $color = $_;
		my $sizes = size();
		for my $size (@{$sizes}){
			my $size_letter = lc(substr($size->{'title'}, 0, 1));
			my $sku = join("-", $product->{'sku'}, $color->title, $size_letter);
			my $variant = {sku => $sku,
				color => $color->value,
				size => $size->{'value'}, 
				name => join(" ", $color->title, $size->{'title'},  $product->{'name'}),
				uri => join("-", $product->{'uri'}, $size_letter, $color->value),
			};
			push (@variants, $variant);
		}
	}
	return \@variants; 
}

sub navigation{
	my @navigation = (
		['roses', 'nav', 'menu-main', 'Flower', '', '0', '0', undef, '0', '0', '0'],
		['birthday', 'nav', 'menu-main', 'Birthday', '', '0', '0', undef, '0', '0', '0'],
		['flowers', 'nav', 'menu-main', 'Flowers', '', '0', '0', undef, '0', '0', '0'],
		['plants', 'nav', 'menu-main', 'Plants', '', '0', '0', undef, '0', '0', '0'],
		['occasions', 'nav', 'menu-main', 'Occasions', '', '0', '0', undef, '0', '0', '0'],
		['sympathy', 'nav', 'menu-main', 'Sympathy', '', '0', '0', undef, '0', '0', '0'],
		['gift-baskets', 'nav', 'menu-main', 'Gift Baskets', '', '0', '0', undef, '0', '0', '0'],
		['specialty-gifts', 'nav', 'menu-main', 'Specialty Gifts', '', '0', '0', undef, '0', '0', '0'],
		['same-day', 'nav', 'menu-main', 'Same Day', '', '0', '0', undef, '0', '0', '0'],
		['sale', 'nav', 'menu-main', 'Sale', '', '0', '0', undef, '0', '0', '0'],
		['login', 'auth', 'top-login', 'Login', '', '0', '0', undef, '0', '0', '0'],
		['registration', 'nav', 'top-right', 'Sign Up', '', '0', '0', undef, '0', '0', '0'],
		['forum', 'nav', 'top-left', 'Forum', '', '0', '0', undef, '0', '0', '0'],
		['about-us', 'nav', 'top-left', 'About Us', '', '0', '0', undef, '0', '0', '0'],
		['orders', 'nav', 'top-left', 'Orders', '', '0', '0', undef, '0', '0', '0'],
		['customer-service', 'nav', 'top-left', 'Customer Service', '', 'customer-service', '0', undef, '0', '0', '0'],
		['logout', 'auth', 'top-logout', 'Logout', '', '', '0', undef, '0', '0', '0']
	);
	
	my $navigation = [
		[ 'uri', 'type', 'scope', 'name', 'description', 'template', 'alias', 'parent_id', 'priority', 'product_count', 'active'],
		@navigation,
	];
	return $navigation;
}

sub colors{
	my $data = Faker::Provider::Color->new(generator=>$fake)->data;
	my $color_names = $data->{'all_color_data'};
	my @colors; 
	foreach (@{$color_names}){
		my $color ->{'title'}= $_;
		$color ->{'value'}= lc($_);
		push(@colors, $color);
	}
	@colors = sort { $a->{'value'} cmp $b->{'value'} } @colors;
	return \@colors;
}

sub size{
	my $size = [{value => 'small', title => 'Small', priority => 2},
		{value => 'medium', title => 'Medium', priority => 1},
                {value => 'large', title => 'Large', priority => 0},
	];
	return $size;
}

sub orders{
	my $userid = shift;
	my $rand_int = rand_int(3, 20);
	my $shipping_address = shop_address->search({
		'users_id' => $userid,
		'type' => 'shipping',
	})->first;
		
	my $billing_address = shop_address->search({
		'users_id' => $userid,
		'type' => 'billing',
	})->first;
	
	unless( $shipping_address && $billing_address){
		return 1;
	}; 
	
	my @product =  $shop_schema->resultset('Product')->search(
	{
		'canonical_sku' => undef,
	},
	{limit =>$rand_int,
	order_by=> \'RAND()'}
	)->all;
	
	my (@orderlines, $weight, $subtotal);
	foreach(1...$rand_int){
		my $rand = rand_int(3, 20);
		push @orderlines, {
			sku => $product[$_]->sku,
			order_position => $_,
			name => $product[$_]->name,
			short_description => $product[$_]->short_description,
			description => $product[$_]->description,
			weight => $product[$_]->weight,
			quantity => $rand,
			price => $product[$_]->price,
			subtotal => $product[$_]->price * $rand,
		};
		$weight += $product[$_]->weight;
		$subtotal += $product[$_]->price * $rand;
		
	}
	
	my $date = $fake->date_this_year;
	$date =~ s/T/ /g;
	my $order_data = shop_order->create({
                order_date => $date,
                users_id => $userid,
                billing_addresses_id => $billing_address->id,
                shipping_addresses_id => $shipping_address->id,
		weight => $weight,
		subtotal => $subtotal,
                Orderline => \@orderlines,
	});
	
	$date =~ s/\D//g;
	$order_data->update({
			order_number => 'UID'.$userid.$date.'OID'.$order_data->orders_id,
		});
}

sub height{
	my $height = [{value => '10', title => '10cm'},
			{value => '20', title => '20cm'},
			{value => '30', title => '30cm'},
			{value => '40', title => '40cm'},
			{value => '50', title => '50cm'},
			];
	return $height;
}

sub data{
	my $sku = shift;
	my ($name, $uri, $short_description, $description);
	$name = join(" ",$fake->jargon_buzz_word,$fake->jargon_buzz_word,$fake->jargon_buzz_word);
	$uri = join("-",$sku,$name);
	$uri =~ s/ /-/g;
	$name = ucfirst($name);
	$short_description = join(" ", $name,  $fake->catch_phase);
	$description =  join(" ", $name,  $fake->catch_phase, $fake->catch_phase);
	return($name, $uri, $short_description, $description);
}
sub price {
	my ($price);
	$price = parse(q{ FLOAT (9) [0-9]{3} . [1-9]{2}})->get_unique_data(1);
	return sprintf ("%.2f",$price->[0]);
}

sub weight{
	my ($weight);
	$weight = parse(q{INT [1-99]})->get_unique_data(1);
	return $weight->[0];
}

sub rand_int{
	my ($x, $y) = @_;
	my $rand=int( rand( $y-$x+1 ) ) + $x;
	return $rand;
};

sub unique_colors{
	my $array_size = shift;
	my @colors = $shop_schema->resultset('Attribute')->search(
	{
		'name' => 'color',
	},
	)->search_related('AttributeValue');
	
	my $rand = parse("INT [0-".($#colors-1)."]")->get_unique_data($array_size);
	my @unique_colors;
	foreach (@{$rand}){
		push(@unique_colors, $colors[$_]);
	}
	@unique_colors = sort { $a->value cmp $b->value } @unique_colors;
	return \@unique_colors;
}

sub uniqe_varchar{
	my $count = shift;
	#generate uniqe varchar list
	my $data = parse(q{VC(10) [A-Z][1-14][a-z][2579]{4}[A-Z][14]{2}});
	my $freedom = $data->get_degrees_of_freedom();
	if($freedom < $count){
		die "Max unique value count exceeded. Please set value below $freedom."
	}
	my $varchars=$data->get_unique_data($count); 
	return $varchars;
}
1;
