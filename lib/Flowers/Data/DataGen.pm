package Flowers::Data::DataGen;

use strict;
use warnings;

use Dancer ':script';

#Random data generators
use Faker;
use Data::Generate qw{parse};

use utf8;

my $fake = Faker::Factory->new(locale => 'en_US')->create;

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
	my $no_products = shift;
	my $skus = uniqe_varchar($no_products);
	#generate product parents
	my @products;
	for my $sku(@{$skus}){
		my $product;
		my ($name, $uri,  $short_description, $description) = data($sku);
		$product = {sku => $sku,
			name => $name,
			short_description => $short_description,
			description =>  $description,
			price => price(),
			uri => $uri,
			canonical_sku => undef,
			weight => weight()
		};
		push (@products, $product);
	}
	return \@products;
}
#generate product variants
sub variants{
	my ($product, $no_colors) = @_;
	my $max_children_no = $no_colors || rand_int(0, $#{colors()}-1);
	my @variants;
	my $colors = uniqe_colors($max_children_no);
	foreach (@{$colors}){
		my $color = $_;
		my $sizes = size();
		for my $size (@{$sizes}){
			my $size_letter = lc(substr($size->{'title'}, 0, 1));
			my $sku = join("-", $product->{'sku'}, $color->{'title'}, $size_letter);
			my $variant = {sku => $sku,
				color => $color->{'value'},
				size => $size->{'value'}, 
				name => join(" ", $color->{'title'}, $size->{'title'},  $product->{'name'}),
				uri => join("-", $product->{'uri'}, $size_letter, lc($color->{'value'})),
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
	return \@colors;
}

sub size{
	my $size = [{value => 'small', title => 'Small', priority => 2},
		{value => 'medium', title => 'Medium', priority => 1},
                {value => 'large', title => 'Large', priority => 0},
	];
	return $size;
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

sub rand_array{
	my $no_products = shift;
	my $rand = parse("INT [0-".($no_products -1)."]")->get_unique_data(rand_int(1,$no_products /3));
	return  $rand;
}

sub rand_int{
	my ($x, $y) = @_;
	my $rand=int( rand( $y-$x+1 ) ) + $x;
	return $rand;
};

sub uniqe_colors{
	my $array_size = shift;
	my @colors = @{colors()};
	my $rand = parse("INT [0-".($#colors-1)."]")->get_unique_data($array_size);
	my @uniqe_colors;
	foreach (@{$rand}){
		push(@uniqe_colors, $colors[$_]);
	}
	return \@uniqe_colors;
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
