package App::Intelligentsia::Message;

use Moose;
use Moose::Util qw(apply_all_roles);

use namespace::clean;

our $VERSION = '0.01';

has author => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has type => (
    is => 'ro',
    isa => 'Str', # enum later
    required => 1,
);

has content => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has source => (
    is => 'ro',
    does => 'Account',
    required => 1,
);

sub BUILD {
    my ( $self, $args ) = @_;

    if(exists $args->{'object_roles'}) {
        my $roles = $args->{'object_roles'};
        unless(ref $roles) {
            $roles = [ $roles ];
        }
        Moose::Util::apply_all_roles($self, @$roles);
    }
};

1;

__END__
=head1 NAME

App::Intelligentsia::Message

=head1 VERSION

0.01

=head1 SYNOPSIS

  use App::Intelligentsia::Message;

  my $msg = App::Intelligentsia::Message->new(
    author => 'hoelzro',
    content => 'Hello!',
    type => 'normal',
    source => $account,
    object_roles => 'Dent',
  );

=head1 DESCRIPTION

Message objects are generic messages (tweets, dents, what have you) that come
from Account objects are are pushed through the message pipeline.  Message
objects have a few common attributes, but Account objects can apply roles to
them to add more.

=head1 ATTRIBUTES

=head2 author

The name of the person who wrote the message.

=head2 type

The type of message (normal, reply, direct).

=head2 content

The textual content of the message.

=head2 source

The Account from which the message came.

=head1 METHODS

=head2 App::Intelligentsia::Message->new(%params)

Creates a new message object.  All of the attributes are acceptable
parameters, in addition to 'object_roles', which is a role (or list
of roles) to apply to the object upon creation.

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
