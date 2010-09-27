package App::Intelligentsia::Message::Tweet;

use Moose::Role;

our $VERSION = '0.01';

requires 'content';

## how does this work when composed into a
## mutable/immutable class?
has tags => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    builder => 'setup_tags',
);

has mentions => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    builder => 'setup_mentions',
);

## refactor
sub setup_tags {
    my ( $self ) = @_;

    my @tags;
    my $content = $self->content;

    while($content =~ /#(?<tag>\w+)/g) {
        push @tags, $+{'tag'};
    }
    return \@tags;
}

sub setup_mentions {
    my ( $self ) = @_;

    my @mentions;
    my $content = $self->content;

    while($content =~ /\@(?<mention>\w+)/g) {
        push @mentions, $+{'mention'};
    }
    return \@mentions;
}

1;

__END__

=head1 NAME

App::Intelligentsia::Message::Tweet

=head1 VERSION

0.01

=head1 SYNOPSIS

  App::Intelligentsia::Message->new(
    ...,
    object_roles => 'Dent',
  );

=head1 DESCRIPTION

This role allows you to treat a message as a post from Twitter,
or at least a social network platform that uses the Twitter API.

=head1 ATTRIBUTES

=head2 tags

The list of hashtags that were in the message.

=head2 mentions

The list of mentions that were in the message.

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
