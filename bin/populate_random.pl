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

my @colours = @{Flowers::Data::DataGen::colors()};

#asking for argumentas
my $no_products = 100; 
my $no_colors;
GetOptions ('products=i' => \$no_products, 'colors=i' => \$no_colors) 
or print "Warning: $!
Usage:
-p  : define number of products you want to generate, defaults to 100,
-c  : number of diferent colors for each product, value between 1 and ".$#colours.", defaults to random.\n";

print "Preparing records for populating countries.\n";
my $pop_countries = Interchange6::Schema::Populate::CountryLocale->new->records;

print "Preparing records for populating states.\n";
my $pop_states = Interchange6::Schema::Populate::StateLocale->new->records;

my $shop_schema = shop_schema;

shop_schema->deploy({add_drop_table => 1,
                     producer_args => {
                         mysql_version => 5,
                     },
                 });

my @attributes = ({name => 'color', title => 'Color'});
#populate countries
print "Populating countries.\n"; 
$shop_schema->populate('Country', $pop_countries);
#populate states
print "Populating states.\n";
$shop_schema->populate('State', $pop_states);

print "Generating and populating roles.\n";
# populate roles table
$shop_schema->populate('Role', [
[ 'name', 'label' ],
@{Flowers::Data::DataGen::roles()},
]);

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

# create color attribute
print "Generating and populating atributes.\n";
my $color_data = {name => 'color', title => 'Color', type => 'variant', priority => 2,
                  AttributeValue => \@colours};

my $color_att = $shop_schema->resultset('Attribute')->create($color_data);

# create size attribute
my $size_data = {name => 'size', title => 'Size', type => 'variant', priority => 1,
                  AttributeValue => Flowers::Data::DataGen::size()};

my $size_att = $shop_schema->resultset('Attribute')->create($size_data);

# create height attribute
my $height_data = {name => 'height', title => 'Height', type => 'variant', priority => 0,
                   AttributeValue =>Flowers::Data::DataGen::height()};

my $height_att = $shop_schema->resultset('Attribute')->create($height_data);


#generating products data
print "Preparing records for populating products.\n";
my $products = Flowers::Data::DataGen::products($no_products);
my @products = @{$products};

print "Populating products and generating and populating variants.\n";
my $progress = Term::ProgressBar->new ({count => $no_products, name => 'Products', ETA   => 'linear'});
my $so_far;
foreach(@{$products}){
	$so_far++;
	my $variants = Flowers::Data::DataGen::variants($_, $no_colors);
	my $product_g = $shop_schema->resultset('Product')->create($_)->add_variants(@{$variants});
	$progress->update ($so_far);
}

print "Populating navigation.\n";
# populate navigation table
scalar $shop_schema->populate('Navigation', Flowers::Data::DataGen::navigation());

# create navigation_id hash
my %nid;

my $nav = $shop_schema->resultset('Navigation')->search(
    {
        'scope' => 'menu-main',
    },
);
while (my $record = $nav->next) {
    $nid{$record->name} = $record->navigation_id;
    foreach (@{Flowers::Data::DataGen::rand_array($no_products)}){
		$shop_schema->resultset('NavigationProduct')->create({sku => $products[$_]->{'sku'},
		navigation_id => $nid{$record->name}});
	}
};