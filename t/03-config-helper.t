use strict;
use warnings;

use Test::More tests => 22;

use App::Intelligentsia::ConfigHelper;

can_ok(__PACKAGE__, 'has');
can_ok(__PACKAGE__, 'has_config');
can_ok(__PACKAGE__, 'meta');

has foo => (
    is => 'ro',
);

has_config bar => 'DefaultValue';

has_config baz => (
    isa => 'Maybe[HashRef]',
    default => sub {
        {},
    }
);

has_config quux => (
    isa => 'ArrayRef',
    default => sub {
        []
    },
);

my $meta = __PACKAGE__->meta;
my ( $foo, $bar ) = map { $meta->get_attribute($_) } qw/foo bar/;

ok($foo->does('App::Intelligentsia::Config::Attribute'));
ok($bar->does('App::Intelligentsia::Config::Attribute'));
ok(! $foo->config_attr);
ok($bar->config_attr);

ok($bar->trigger);
is('DefaultValue', $bar->default);

my $object = __PACKAGE__->new;

is($object->foo, undef);
is($object->bar, 'DefaultValue');
$object->bar('AnotherValue');
is($object->bar, 'AnotherValue');
$object->bar;
is($object->bar, 'AnotherValue');
$object->bar(undef);
is($object->bar, 'DefaultValue');

is_deeply($object->baz, {});
$object->baz->{'one'} = 1;
is_deeply($object->baz, { one => 1 });
$object->baz;
is_deeply($object->baz, { one => 1 });
$object->baz(undef);
is_deeply($object->baz, {});

is_deeply($object->quux, []);
push @{ $object->quux }, 1;
is_deeply($object->quux, [1]);
$object->quux;
is_deeply($object->quux, [1]);
$object->quux(undef);
is_deeply($object->quux, []);
