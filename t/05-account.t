use strict;
use warnings;

use Test::More tests => 2;

use_ok 'App::Intelligentsia::Account';
can_ok('App::Intelligentsia::Account', 'create');
