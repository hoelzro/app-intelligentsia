use strict;
use warnings;

use Test::More tests => 6;
use Test::Exception;

use Moose -traits => ['Immutable'];

my $meta = __PACKAGE__->meta;

has foo => (
);

ok($meta->has_attribute('foo'));
my $attr = $meta->get_attribute('foo');
ok(! $attr->get_write_method);

has bar => (
    is => 'ro',
);
ok($meta->has_attribute('bar'));
$attr = $meta->get_attribute('bar');
ok(! $attr->get_write_method);

dies_ok {
    has baz => (
        is => 'rw',
    );
};
ok(! $meta->has_attribute('baz'));
