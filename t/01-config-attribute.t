use strict;
use warnings;

use Test::More tests => 7;

use Moose;

has one => (
    is => 'ro',
);

has two => (
    is => 'ro',
    traits => [qw/ConfigAttribute/],
);

has three => (
    is => 'ro',
    traits => [qw/ConfigAttribute/],
    config_attr => 0,
);

has four => (
    is => 'ro',
    traits => [qw/ConfigAttribute/],
    config_attr => 1,
);

my $meta = __PACKAGE__->meta;

my ( $one, $two, $three, $four ) = map { $meta->get_attribute($_) } qw/one two three four/;

ok(! $one->does('App::Intelligentsia::Config::Attribute'));
ok($two->does('App::Intelligentsia::Config::Attribute'));
ok($three->does('App::Intelligentsia::Config::Attribute'));
ok($four->does('App::Intelligentsia::Config::Attribute'));

ok(! $two->config_attr);
ok(! $three->config_attr);
ok($four->config_attr);
