package App::Intelligentsia::MessageSink;

use Moose::Role;
use Moose::Util::TypeConstraints qw(role_type);

use namespace::clean;

our $VERSION = '0.01';

role_type MessageSink => {
    role => __PACKAGE__,
};

requires 'take';

1;

__END__

=head1 NAME

App::Intelligentsia::MessageSink

=head1 VERSION

0.01

=head1 SYNOPSIS

  use Moose;

  with 'App::Intelligentsia::MessageSink';

  sub take {
    my ( $self, $msg ) = @_;

    # do something with $msg
  }

=head1 DESCRIPTION

Message sinks are general components of the message pipeline.  Account objects
are responsible for pulling messages off of the network, but message sinks are
responsible for processing them.  This is a very abstract role, because message
sinks can do so much.  Message sinks can be in the following forms, but the
list is hardly exhaustive:

=head2 UIs

UI implementations are message sinks that display their incoming messages.

=head2 Filters

Filters are message sinks that forward their messages to other sinks depending
on a set of criteria.

Now that I think about it, message sinks should probably be called message
pipes or something.

=head1 METHODS

=head2 $sink->take($msg)

Process an App::Intelligentsia::Message C<$msg>.

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
