package App::Intelligentsia;

use MooseX::Singleton;

our $VERSION = '0.01';

use AnyEvent;

use App::Intelligentsia::Account;
use App::Intelligentsia::Config;
use App::Intelligentsia::UI;

has cond => (
    is => 'ro',
    default => sub {
        AnyEvent->condvar;
    },
    handles => {
        loop => 'recv',
    },
);

has config => (
    is => 'ro',
    isa => 'Config',
    default => sub {
        App::Intelligentsia::Config->new;
    },
);

has ui => (
    is => 'ro',
    isa => 'UI',
    default => sub {
        App::Intelligentsia::UI->new;
    },
);

has accounts => (
    is => 'ro',
    isa => 'ArrayRef[Account]',
    auto_deref => 1,
    traits => [qw/Array/],
    default => sub {
        [];
    },
    handles => {
        add_account => 'push',
    },
);

sub run {
    my ( $self ) = @_;

    $self->config->load;
    $self->ui->initialize($self->config->ui);
    foreach my $account ($self->config->accounts) {
        $self->add_account(App::Intelligentsia::Account->create($account));
    }
    $self->loop;
}

1;

__END__

# ABSTRACT: A graphical Identica/Twitter client

=head1 NAME

App::Intelligentsia

=head1 VERSION

0.01

=head1 SYNOPSIS

use App::Intelligentsia;

App::Intelligentsia->run;

=head1 DESCRIPTION

Intelligentsia is a client for Identica and Twitter.

=head1 METHODS

=head2 App::Intelligentsia->run

Runs the Intelligentsia application.

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

=cut
