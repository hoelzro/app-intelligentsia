use strict;
use warnings;

use Test::More tests => 6;
use Test::Deep qw(cmp_bag);

use metaclass 'App::Intelligentsia::Config::MetaClass';
use Moose;

has one => (
    is => 'ro',
);

has two => (
    is => 'ro',
    config_attr => 0,
);

has three => (
    is => 'ro',
    config_attr => 1,
);

has four => (
    is => 'ro',
    config_attr => 1,
);

my $meta = __PACKAGE__->meta;

foreach my $name ($meta->get_attribute_list) {
    ok($meta->get_attribute($name)->does('App::Intelligentsia::Config::Attribute'));
}
can_ok($meta, 'get_config_attribute_list');
cmp_bag([$meta->get_config_attribute_list], [qw/three four/]);
