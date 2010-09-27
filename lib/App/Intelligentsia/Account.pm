package App::Intelligentsia::Account;

use Carp qw(croak);
use Module::Find qw(usesub);
use Moose::Role -traits => 'AccountWatcher';
use Moose::Util::TypeConstraints qw(role_type);

use namespace::clean;

our $VERSION = '0.01';

role_type Account => {
    role => __PACKAGE__,
};

requires 'send_message';
requires 'build_watcher';

has watcher => (
    is => 'ro',
    builder => 'build_watcher',
);

has sink => (
    is => 'rw',
    does => 'MessageSink',
    required => 1,
);

my $has_checked_path;
my %account_types;

sub create {
    my $self = shift;
    my %config;

    if(@_ == 1) {
        %config = %{ $_[0] };
    } else {
        %config = @_;
    }

    unless(exists $config{'type'}) {
        croak "The config option to App::Intelligentsia::Account::create must contain a 'type' field";
    }
    my $type = delete $config{'type'};
    my $class = $self->get_account_class($type);

    my $result;
    eval {
        $result = $class->new(%config);
    };
    if($@) {
        croak "Unable to create account of type '$type': $@";
    }
    return $result;
}

sub get_account_class {
    my ( $self, $type ) = @_;

    if(exists $account_types{$type}) {
        return $account_types{$type};
    } else {
        unless($has_checked_path) {
            ## maybe we shouldn't do this lazily? (the output of types changes)
            usesub App::Intelligentsia::Account;
            $has_checked_path = 1;
            return $self->get_account_class($type);
        }
        croak "No such account type '$type'";
    }
}

sub register_type {
    my ( undef, $name, %options ) = @_;

    my $pristine = $name;
    $name =~ s/App::Intelligentsia::Account:://g;
    $account_types{$name} = $pristine;
}

sub types {
    return { %account_types };
}

1;

__END__

=head1 NAME

App::Intelligentsia::Account

=head1 VERSION

0.01

=head1 SYNOPSIS

  use App::Intelligentsia::Account;

  my $account = App::Intelligentsia::Account->create(\%config);

  # or

  use Moose;

  with 'App::Intelligentsia::Account';

=head1 DESCRIPTION

The Account role is the base role for all types of accounts.  The two ways to
use App::Intelligentsia::Account are to either consume the role, or to use
App::Intelligentsia::Account->create to dynamically create an account object
from a configuration hash.  App::Intelligentsia::Account maintains a set
of known account types; consumers of this role do not need to explicitly add
themselves to the type mapping; App::Intelligentsia::Account knows when
classes consume it.

=head1 ATTRIBUTES

=head2 watcher

An L<AnyEvent> watcher that corresponds to this account.  It may be watching a
socket, a timer, or whatever.

=head2 sink

An L<App::Intelligentsia::MessageSink>.  Messages read off of this account
will be sent to this sink.

=head1 REQUIRED METHODS

=head2 $account->send_message($msg)

Sends an L<App::Intelligentsia::Message> (C<$msg>) via the given account.

=head2 $account->build_watcher()

Builds the L<AnyEvent> watcher.

=head1 CLASS METHODS

=head2 App::Intelligentsia::Account->create(\%config)

Creates an account object from C<%config>.  C<%config> should contain a key
'type', which will create an object of class
C<App::Intelligentsia::Account::$type>.  That class is expected to consume
the App::Intelligentsia::Account role.

=head2 App::Intelligentsia::Account->get_account_class($type)

Returns the class name that corresponds to the account type C<$type>.
You shouldn't need to use this method.

=head2 App::Intelligentsia::Account->register_type($package, %options)

Registers the package C<$package> as an account type.  The type name
is the same as C<$package>, only if it is a subpackage of
App::Intelligentsia::Account, that prefix is stripped off.  C<%options>
is currently unused.  You shouldn't need to use this method.

=head2 App::Intelligentsia::Account->types

Returns a hash reference that has the account type names as keys, and
the classes they correspond to as values.  Modifying this hash will not
affect the type bindings in App::Intelligentsia::Account, and may throw
an error at a later time.

=head1 AUTHOR

Rob Hoelz, C<< rob at hoelz.ro >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-App-Intelligentsia at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Intelligentsia>. I will
be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2010 Rob Hoelz.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

C<App::Intelligentsia>

=cut
