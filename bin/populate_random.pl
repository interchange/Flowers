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

use Flowers::Data::DataGen;
use Flowers::Data::DataPop;

use Getopt::Long;
use Term::ProgressBar;
use Term::UI;

use Tie::IxHash;

my $shop_schema = shop_schema;

my $term = Term::ReadLine->new('brand');
my @colours = @{Flowers::Data::DataGen::colors()};
tie my %actions, "Tie::IxHash"
    or die 'could not tie %{$actions}';
%actions = (
	dbcreate => \&Flowers::Data::DataPop::create_db,
	countries => \&Flowers::Data::DataPop::pop_countries,
	users => \&Flowers::Data::DataPop::pop_users,
	attributes => \&Flowers::Data::DataPop::pop_attributes,
	products => \&Flowers::Data::DataPop::pop_products,
	navigaton => \&Flowers::Data::DataPop::pop_navigation,
	orders => \&Flowers::Data::DataPop::pop_orders
);

#asking for argumentas
my $usage = "Usage:
-g  : create complete database and generate data for all tables,
-d  : remove existing database and creates new one,
-c  : generate data for country and state table,
-u  : generate data for user and roles table,
-a  : generate data for attribute table,
-p  : generate data for products table,
-n  : generate data for navigation table,
-o  : generate data for orders table.\n";

GetOptions (
	'help'  => \&help,
	'generate' => \&handler,
	'dbcreate'=> \&handler, 
	'countries' => \&handler,
	'users' => \&handler,
	'attributes' => \&handler,
	'products' => \&handler,
	'navigaton' => \&handler,
	'orders' => \&handler,
) or print "Warning: $! \n $usage";

my ($no_colors, $no_products, $no_orders);
sub help {
	print $usage;
}

sub handler {
	my ($opt_name, $opt_value) = @_;
	if($opt_name eq 'generate'){
		foreach(keys %actions){
			interface($_);
			print "Populating $_.\n";
		};
		exit 0;
	}else{
		print "Populating $opt_name.\n";
		interface($opt_name);
	}
}

sub interface{
	my $action = shift;
	
	if($action eq 'dbcreate'){
		my $bool = $term->ask_yn(
			prompt => "This option will delete all records and recreate your DB.\n Are you sure?",
			default => 'y',
			);
		if($bool){
			$actions{$action}->();
		};
	}elsif($action eq 'products'){
		$no_products = $term->get_reply(
			prompt  => 'What is the number of products you want to generate?',
			default => '100' );
		$no_colors = $term->get_reply(
			prompt  => 'What is the number of colors for each product you want to generate?',
			default => '5' );
		print "Generating ".(($no_products*$no_colors*3)+$no_products)." records.\n";
		$actions{$action}->($no_products, $no_colors);
	}elsif($action eq 'orders'){
		$no_orders = $term->get_reply(
			prompt  => 'What is the number of orders for each user you want to generate?',
			default => '5' );
		print "Generating orders.\n";
		$actions{$action}->($no_orders);
	}else{
		$actions{$action}->();
	};
}



1;