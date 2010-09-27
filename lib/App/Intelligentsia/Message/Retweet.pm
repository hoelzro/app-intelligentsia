package App::Intelligentsia::Message::Retweet;

use Moose::Role;

our $VERSION = '0.01';

has original_author => (
    is => 'ro',
    isa => 'Str',
);

sub is_repeat {
    return 1;
}

1;

__END__

=head1 NAME

App::Intelligentsia::Message::Retweet

=head1 VERSION

0.01

=head1 SYNOPSIS

  App::Intelligentsia::Message->new(
    ...,
    object_roles => 'Retweet',
  );

=head1 DESCRIPTION

This role allows you to treat a message as a retweet/redent/rewhatever.
It should probably be renamed.

=head1 ATTRIBUTES

=head2 original_author

The original author of the message's content.

=head1 METHODS

=head2 $msg->is_repeat

Returns true.

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

C<App::Intelligentsia>, C<App::Intelligentsia::Message>

=cut
