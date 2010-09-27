package App::Intelligentsia::Message::Dent;

use Moose::Role;

with 'App::Intelligentsia::Message::Tweet';

our $VERSION = '0.01';

has groups => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    builder => 'setup_groups',
);

sub setup_groups {
    my ( $self ) = @_;

    my @groups;
    my $content = $self->content;

    while($content =~ /!(?<group>\w+)/g) {
        push @groups, $+{'group'};
    }
    return \@groups;
}

1;

__END__

=head1 NAME

App::Intelligentsia::Message::Dent

=head1 VERSION

0.01

=head1 SYNOPSIS

  App::Intelligentsia::Message->new(
    ...,
    object_roles => 'Dent',
  );

=head1 DESCRIPTION

This role allows you treat a message as a post from Identi.ca,
or at least from a StatusNet instance.

=head1 ATTRIBUTES

Everything App::Intelligentsia::Message::Tweet has, and more!

=head2 groups

The list of groups that were in the message.

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
