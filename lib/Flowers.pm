package Flowers;

use Dancer ':syntax';
use Dancer::Plugin::Nitesi;

use Flowers::Routes::Account;
    
our $VERSION = '0.0001';

get '/' => sub {
    template 'index';
};

get qr{/?(?<path>.*)} => sub {
    my $path;

    $path = captures->{path};

    if (navigation($path)) {
	debug ("path $path is valid.");
    }
    else {
	debug("Catch all: ", captures->{page});
    }
    
    template 'index';
};

sub menu {
    # pulls out menu data from navigation table
};

sub _build_query_path {
    my ($path) = @_;
    my ($nav_config, %nav_parms);

    # defaults
    %nav_parms = (table => 'navigation',
		  uri_field => 'uri',
		  link_table => 'navigation_products',
		  link_field => 'navigation',
		  items_table => 'products',
		  items_link_field => 'sku',
	);

    # overrides from config
    $nav_config = config->{navigation}->{main};

    for (keys %$nav_config) {
	$nav_parms{$_} = $nav_config->{$_};
    }

    return (table => $nav_parms{table},
	    where => {$nav_parms{uri_field} => $path});
}

sub navigation {
    my ($path, $set);
    
    if (@_ == 1) {
	# just check whether path is available in navigation table
	$path = shift;

	$set = query->select(_build_query_path($path));

	if (@$set == 1) {
	    return $set->[0];
	}
    }
};

true;

=head1 NAME

Flowers - Flowers Website

=cut
