#! /usr/bin/env perl
#
## Copyright (c) 2014, Simun Kodzoman (sime-k), Tenalt d.o.o.
##
## This program is free software: you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation, either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
## FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License want to load an environment other than the default, try this:blic License along with
## this program. If not, see <http://www.gnu.org/licenses/>.
###########################################################################

use strict;
use warnings;

use Interchange6::Schema;
use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;

use Dancer ':script';
use Dancer::Plugin::Interchange6;

use Data::Generate qw{parse};
use Flowers::Data::DataGen;

use Getopt::Long;
use Term::ProgressBar;

my $shop_schema = shop_schema;

shop_schema->deploy({add_drop_table => 1,
                     producer_args => {
                         mysql_version => 5,
                     },
                 });
my @colours = @{Flowers::Data::DataGen::colors()};
#asking for argumentas
my $no_products = 100; 
my $no_colors;
GetOptions ('products=i' => \$no_products, 'colors=i' => \$no_colors) 
or print "Warning: $!
Usage:
-p  : define number of products you want to generate, defaults to 100,
-c  : number of diferent colors for each product, value between 1 and ".$#colours.", defaults to random.\n";

pop_countries();
pop_states();
pop_roles();
pop_users();
pop_colors();
pop_size();
pop_height();
pop_products();
pop_navigation();

sub pop_countries{
	print "Populating countries.\n";
	my $pop_countries = Interchange6::Schema::Populate::CountryLocale->new->records;
	#populate countries
	$shop_schema->populate('Country', $pop_countries);
};

sub pop_states{
	print "Populating states.\n";
	my $pop_states = Interchange6::Schema::Populate::StateLocale->new->records;
	#populate states
	$shop_schema->populate('State', $pop_states);
};

sub pop_roles{
	print "Generating and populating roles.\n";
	# populate roles table
	$shop_schema->populate('Role', [
					[ 'name', 'label' ],
					@{Flowers::Data::DataGen::roles()},
				]);
}
sub pop_users{
	#ceating and populating user data
	print "Generating and populating user data.\n";
	my $users = Flowers::Data::DataGen::users();
	foreach(@{$users}){
		my $user = $_->{'user_data'};
		my $user_obj = shop_user->create($user);
		foreach(@{$_->{'address_data'}}){
			$_->{'users_id'} = $user_obj->id; 
			shop_address->create($_);
		};
	}
}

sub pop_colors{
	# create color attribute
	my @colours = @{Flowers::Data::DataGen::colors()};
	print "Generating and populating atributes.\n";
	my $color_data = {name => 'color', title => 'Color', type => 'variant', priority => 2,
			  AttributeValue => \@colours};

	my $color_att = $shop_schema->resultset('Attribute')->create($color_data);
}

sub pop_size{
	# create size attribute
	my $size_data = {name => 'size', title => 'Size', type => 'variant', priority => 1,
			AttributeValue => Flowers::Data::DataGen::size()};

	my $size_att = $shop_schema->resultset('Attribute')->create($size_data);
}

sub pop_height{
	# create height attribute
	my $height_data = {name => 'height', title => 'Height', type => 'variant', priority => 0,
			AttributeValue =>Flowers::Data::DataGen::height()};

	my $height_att = $shop_schema->resultset('Attribute')->create($height_data);
}

sub pop_products{
	#generating products data
	print "Populating and generating populating products.\n";
	my $progress = Term::ProgressBar->new ({count => $no_products, name => 'Products', ETA   => 'linear'});
	my $so_far;
	my $skus = Flowers::Data::DataGen::uniqe_varchar($no_products);
	my @products;
	foreach(@{$skus}){
		$so_far++;
		my $product = Flowers::Data::DataGen::products($_);
		my $variants = Flowers::Data::DataGen::variants($product, $no_colors);
		my $product_g = $shop_schema->resultset('Product')->create($product)->add_variants(@{$variants});
		push (@products, $product);
		$progress->update ($so_far);
	}
	return \@products;
}

sub pop_navigation{
	print "Populating navigation.\n";
	# populate navigation table
	scalar $shop_schema->populate('Navigation', Flowers::Data::DataGen::navigation());
	# create navigation_id hash

	my @nav = $shop_schema->resultset('Navigation')->search(
	{
		'scope' => 'menu-main',
	},
	)->all;
	
	my $products =  $shop_schema->resultset('Product')->search;
	my $nav_progress = Term::ProgressBar->new ({count => $products ->count, name => 'Navigation', ETA   => 'linear'});
	my $count;
	while (my $product = $products->next) {
		$count++;
		my $ran = Flowers::Data::DataGen::rand_int(0, $#nav);
		$shop_schema->resultset('NavigationProduct')->create({sku => $product->sku,navigation_id => $nav[$ran]->navigation_id});
		$nav_progress->update ($count);
	}
};