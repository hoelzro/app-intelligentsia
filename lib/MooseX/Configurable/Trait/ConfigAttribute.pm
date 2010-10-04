package MooseX::Configurable::Trait::ConfigAttribute;

use Moose::Role;

our $VERSION = '0.01';

has config => (
    is => 'ro',
    isa => 'Bool',
    default => 0,
);

has section => (
     is => 'ro',
     isa => 'Str',
     default => 'General',
);

has label => (
    is => 'ro',
    isa => 'Str',
    default => sub {
        my ( $self ) = @_;

        my $name = $self->name;

        $name =~ s/_/ /g;
        $name =~ s/([a-z0-9_])([A-Z])/$1 . ' ' . $2/ge;
        $name =~ s/\b([a-z])/uc $1/ge;

        return $name;
    },
);

has index => (
    is => 'ro',
    isa => 'Int',
    default => 0,
);

1;

__END__

=head1 NAME

MooseX::Configurable::Trait::ConfigAttribute

=head1 VERSION

0.01

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

L<MooseX::Configurable>

=cut
