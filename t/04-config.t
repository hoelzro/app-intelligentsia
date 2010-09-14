#!/usr/bin/env perl

use 5.12.0;
use autodie qw(chmod open);
use warnings;

use Moose;
use App::Intelligentsia::Config;
use Data::Dumper;
use Guard qw(scope_guard);
use IO::String;
use File::Spec::Functions qw(catfile);
use File::Temp;
use Symbol qw(gensym);
use YAML qw(Load LoadFile);

use Test::More;
use Test::Exception;

my %default_attrs = (
    ui => 'Gtk',
    accounts => [],
);

sub unslurp {
    my ( $filename, $contents ) = @_;

    open my $fh, '>', $filename;
    print $fh $contents;
    close $contents;
}

sub run_load_tests {
    my ( $tests, $constructor_args ) = @_;
    foreach my $test (@$tests) {
        my ( $contents, $perms ) = @{$test}{qw/contents perms/};

        $perms //= 0644;

        for(my $i = 0; $i < @$constructor_args; $i += 2) {
            my ( $load_should_die, $expected_attrs ) = @{$test}{qw/load_should_die expected_attrs/};
            my ( $filename, $args ) = @{$constructor_args}[$i, $i + 1];

            unless(defined $filename) {
                $load_should_die = 1;
                $expected_attrs = \%default_attrs;
            }

            unlink $filename if defined $filename;
            if(defined $filename && defined $contents) {
                unslurp $filename => $contents;
                chmod $perms, $filename;
            }
            my $config = App::Intelligentsia::Config->new(@$args);

            if($load_should_die) {
                dies_ok {
                    $config->load;
                };
            } else {
                $config->load;
                ok(1);
            }
            while(my ( $k, $v ) = each %$expected_attrs) {
                is_deeply($config->$k(), $v);
            }
            is($config->filename, $filename);
        }
    }
}

unless($ENV{'INTELLIGENTSIA_TEST_CONFIG'}) {
    plan skip_all => 'Set INTELLIGENTSIA_TEST_CONFIG to test the Config class (warning, this test touches your filesystem!)';
    exit 0;
}
my $config_file = catfile((getpwuid $<)[7], '.intelligentsiarc');
if(-e $config_file) {
    plan skip_all =>  '$HOME/.intelligentsiarc exists; exiting. Please rename it to allow the test to proceed';
    exit 0;
}
scope_guard {
    unlink $config_file;
};

# silence warnings for now
$SIG{__WARN__} = sub {};

my $temp_file = File::Temp->new(SUFFIX => '.yml', TMPDIR => 1);
my $temp_filename = $temp_file->filename;
$Data::Dumper::Terse = 1;
$| = 1;

print $temp_file <<YAML;
---

ui: Cocoa
YAML

has config => (
    is => 'ro',
    isa => 'Config',
    default => sub {
        App::Intelligentsia::Config->new
    },
);

my @attributes = App::Intelligentsia::Config->meta->get_attribute_list;

my $fh = gensym;
tie *$fh, 'IO::String', <<YAML;
---

ui: Cocoa
accounts:
  -
    type: Twitter
YAML

my $handle = IO::String->new(<<YAML);
---

ui: Cocoa
accounts:
  -
    type: StatusNet
YAML

my $fh2 = gensym;
tie *$fh2, 'IO::String', <<YAML;
---

ui: Cocoa
accounts:
  -
    type: Twitter
YAML

my $handle2 = IO::String->new(<<YAML);
---

ui: Cocoa
accounts:
  -
    type: StatusNet
YAML

my @arg_lists = (
    [] => { filename => $config_file, ui => 'Gtk', accounts => [] },
    [$temp_filename] => { filename => $temp_filename, ui => 'Gtk', accounts => [] }, # remember, it doesn't auto load the file!
    [{ui => 'Cocoa'}] => { filename => undef, ui => 'Cocoa', accounts => [] },
    [[accounts => [{ type => 'Identica' }]]] => { filename => undef, ui => 'Gtk', accounts => [{ type => 'Identica' }] },
    [$fh] => { filename => undef, ui => 'Cocoa', accounts => [{ type => 'Twitter' }]},
    [$handle] => { filename => undef, ui => 'Cocoa', accounts => [{ type => 'StatusNet' }]},
    [$temp_filename => {ui => 'Cocoa'}] => { filename => $temp_filename, ui => 'Cocoa', accounts => [] },
    [$temp_filename => [accounts => [{ type => 'Identica' }]]] => { filename => $temp_filename, ui => 'Gtk', accounts => [{ type => 'Identica' }] },
    [$temp_filename => $fh2] => { filename => $temp_filename, ui => 'Cocoa', accounts => [{ type => 'Twitter' }]},
    [$temp_filename => $handle2] => { filename => $temp_filename, ui => 'Cocoa', accounts => [{ type => 'StatusNet' }]},
);

my @load_tests = ({
    expected_attrs => \%default_attrs,
}, {
    contents => '',
    perms => 0000,
    load_should_die => 1,
    expected_attrs => \%default_attrs,
}, {
    contents => <<YAML,
!!! not YAML !!!
YAML
    load_should_die => 1,
    expected_attrs => \%default_attrs,
}, {
    contents => <<YAML,
---

[]
YAML
    load_should_die => 1,
    expected_attrs => \%default_attrs,
}, {
    contents => <<YAML,
---

ui: Cocoa
YAML
    expected_attrs => { %default_attrs, ui => 'Cocoa' },
}, {
    contents => <<YAML,
---

foo: bar
baz: quux
filename: '$temp_filename'
accounts:
  -
    type: Twitter
YAML
    expected_attrs => { %default_attrs, accounts => [{ type => 'Twitter' }] },
});

my @load_filename_tests = ({
    expected_attrs => {
    },
});

my @load_save_constructor_args = (
    $config_file => [],
    $temp_filename => [$temp_filename], 
    undef, [{}], # can't use fat arrow here!
    $temp_filename => [$temp_filename => {}],
);

plan tests => 29
    + (@arg_lists / 2) * (@attributes * 2)
    + (@load_tests * (@attributes + 1)) * (@load_save_constructor_args / 2)
    + (@load_filename_tests * (@attributes + 1)) * (@load_save_constructor_args / 2);

my $obj = __PACKAGE__->new;
my $config = $obj->config;
isa_ok($config, 'App::Intelligentsia::Config');
is($config->filename, $config_file);
$config->filename($temp_filename);
is($config->filename, $temp_filename);
$config->filename(undef);
is($config->filename, undef);

is($config->ui, 'Gtk');
$config->ui('Cocoa');
is($config->ui, 'Cocoa');
$config->ui;
is($config->ui, 'Cocoa');
$config->ui(undef);
is($config->ui, 'Gtk');

is_deeply($config->accounts, []);
push @{ $config->accounts }, {};
is_deeply($config->accounts, [{}]);
$config->accounts;
is_deeply($config->accounts, [{}]);
$config->accounts(undef);
is_deeply($config->accounts, []);


for(my $i = 0; $i < @arg_lists; $i += 2) {
    my ( $args, $expected ) = @arg_lists[$i, $i + 1];

    my $config = App::Intelligentsia::Config->new(@$args);
    foreach my $attr (@attributes) {
        my $expected_value = $expected->{$attr};
        my $actual_value = $config->$attr();
        ok(exists $expected->{$attr});
        
        is_deeply($actual_value, $expected_value) || diag("args = " . Dumper($args) . "attr = $attr");
    }
}

my $dumper = Data::Dumper->new([]);
dies_ok {
    App::Intelligentsia::Config->new($dumper);
};

dies_ok {
    App::Intelligentsia::Config->new($temp_filename, $dumper);
};

dies_ok {
    App::Intelligentsia::Config->new($temp_filename, {}, 1);
};

$config = App::Intelligentsia::Config->new({ filename => $temp_filename });
ok(! defined($config->filename));
$config = App::Intelligentsia::Config->new([ filename => $temp_filename ]);
ok(! defined($config->filename));

$handle = IO::String->new(<<YAML);
---

filename: '$temp_filename'
YAML

$config = App::Intelligentsia::Config->new($handle);
ok(! defined($config->filename));

run_load_tests(\@load_tests, \@load_save_constructor_args);
run_load_tests(\@load_filename_tests, \@load_save_constructor_args, $temp_filename);

unslurp $temp_filename, <<YAML;
---

accounts:
  -
    type: StatusNet
YAML

$config = App::Intelligentsia::Config->new({ ui => 'Cocoa' });
dies_ok {
    $config->load;
};
is($config->ui, 'Cocoa');

$config = App::Intelligentsia::Config->new;
$config->load($temp_filename);
is($config->filename, $temp_filename);
is_deeply($config->accounts, [{ type => 'StatusNet' }]);

$config = App::Intelligentsia::Config->new({ ui => 'Cocoa' });
$config->load($temp_filename);
is($config->filename, $temp_filename);
is($config->ui, 'Gtk');
is_deeply($config->accounts, [{ type => 'StatusNet' }]);

$handle = IO::String->new(<<YAML);
---

accounts:
  -
    type: Twitter
YAML

$config = App::Intelligentsia::Config->new;
$config->load($handle);
is($config->filename, undef);
is_deeply($config->accounts, [{ type => 'Twitter' }]);

unlink $config_file;

$config = App::Intelligentsia::Config->new;
$config->save;
is($config->filename, $config_file);
my $yaml = LoadFile($config_file);
is_deeply($yaml, {
    ui => 'Gtk',
    accounts => [],
});

unlink $temp_filename;

$config = App::Intelligentsia::Config->new({ ui => 'Cocoa' });
dies_ok {
    $config->save;
};
is($config->filename, undef);
$config->save($temp_filename);
is($config->filename, $temp_filename);

$yaml = LoadFile($temp_filename);
is_deeply($yaml, {
    ui => 'Cocoa',
    accounts => [],
});

$handle = IO::String->new;
$config->save($handle);
is($config->filename, undef);
is_deeply(Load(${ $handle->string_ref }), {
    ui => 'Cocoa',
    accounts => [],
});
