package App::Intelligentsia::Account::Identica;

use AnyEvent;
use Moose;
use Net::Identica;

use namespace::clean;

with 'App::Intelligentsia::Account';

our $VERSION = '0.01';

has username => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has password => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has identica => (
    is => 'ro',
    isa => 'Net::Identica',
    builder => 'build_identica',
);

sub build_watcher {
    my ( $self ) = @_;

    return AnyEvent->timer(
        interval => 300,
        cb => sub {
            $self->pump_messages;
        },
    );
}

sub build_identica {
    my ( $self ) = @_;

    my $username = $self->username;
    my $password = $self->password;

    return Net::Identica->new(
        username => $username,
        password => $password,
    );
}

sub send_message {
    my ( $self, $msg ) = @_;

    ...
}

sub pump_messages {
    my ( $self ) = @_;

    my $statuses = $self->identica->home_timeline;
    my $sink = $self->sink;

    foreach my $status (@$statuses) {
        my ( $text, $user ) = @{$status}{qw/text user/};
        $user = $user->{'name'};
        my $msg = App::Intelligentsia::Message->new(
            author => $user,
            content => $text,
            source => $self,
            type => 'normal',
            object_roles => 'App::Intelligentsia::Message::Dent',
        );
        $sink->take($msg);
        # ignored keys (for now):
        # source attachements favorited geo created_at user statusnet_html
        # in_reply_to_user_id id in_reply_to_status_id in_reply_to_screen_name
    }
}

1;

__END__

=head1 NAME

App::Intelligentsia::Account::Identica

=head1 VERSION

0.01

=head1 SYNOPSIS

  use App::Intelligentsia::Account;

  my $account = App::Intelligentsia::Account->create(
    type => 'Identica',
    username => $username,
    password => $password,
  );

=head1 DESCRIPTION

An account class that handles receiving messages from an
Identi.ca account.

=head1 ATTRIBUTES

=head2 username

The username to use for authentication.

=head2 password

The password to use for authentication.

=head2 identica

The Net::Identica instance used for fetching messages.

=head1 FUNCTIONS

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

C<App::Intelligentsia>, C<App::Intelligentsia::Account>

=cut
