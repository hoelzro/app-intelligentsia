package App::Intelligentsia::Account::StatusNet;

use strict;
use warnings;

use AnyEvent;
use Moose;
use Net::Twitter;

use App::Intelligentsia::Message;

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

has api_url => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has api_host => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has api_realm => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has twitter => (
    is => 'ro',
    isa => 'Net::Twitter',
    lazy => 1,
    builder => 'build_twitter',
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

sub build_twitter {
    my ( $self ) = @_;

    return Net::Twitter->new(
        username => $self->username,
        password => $self->password,
        apiurl => $self->api_url,
        apihost => $self->api_host,
        apirealm => $self->api_realm,
    );
}

sub send_message {
    my ( $self, $msg ) = @_;

    ...
}

sub pump_messages {
    my ( $self ) = @_;

    my $statuses = $self->twitter->home_timeline;
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

App::Intelligentsia::Account::StatusNet

=head1 VERSION

0.01

=head1 SYNOPSIS

  my $account = App::Intelligentsia::Account->create(
    type => 'StatusNet',
    username => $username,
    password => $password,
    api_url => $api_url,
    api_host => $api_host,
    api_realm => $api_realm,
  );

=head1 DESCRIPTION

An account class that handles receiving messages from
a StatusNet installation.

=head1 ATTRIBUTES

=head2 username

The username to use for authentication.

=head2 password

The password to use for authentication.

=head2 api_url

The URL of the API.

=head2 api_host

The host of the StatusNet installation.

=head2 api_realm

The API realm of the StatusNet installation.

=head2 twitter

The L<Net::Twitter> used to make API requests.

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
C<App::Intelligentsia::Account>

=cut
