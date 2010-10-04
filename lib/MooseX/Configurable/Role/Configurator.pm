package MooseX::Configurable::Role::Configurator;

use Moose::Role;

our $VERSION = '0.01';

requires 'create';
requires 'edit';

sub default_section_ordering {
    my ( $self, @attributes ) = @_;

    my %sections;
    foreach (@attributes) {
        $sections{$_->section} = 1 unless $_->section eq 'General';
    }
    return ['General', sort keys %sections];
}

1;

__END__

=head1 NAME

MooseX::Configurable::Role::Configurator

=head1 VERSION

0.01

=head1 SYNOPSIS

  # as a role consumer
  use Moose;

  with 'MooseX::Configurable::Role::Configurator';

  sub create {
    my ( $self, $type ) = @_;
  }

  sub edit {
    my ( $self, $object ) = @_;
  }

  # as a client of a configurator
  use My::Configurator;
  use Some::Configurable;

  my $configurator = My::Configurator->New;
  my $object = $configurator->create('Some::Configurable');

=head1 DESCRIPTION

Defines a GUI-configurator for configurable objects.

=head1 METHODS

=head2 $configurator->create($type)

Opens up a modal GUI for creating a new object of type C<$type>.  C<$type>
must be a Moose class.  If C<$type> is an array reference, a UI page should
be displayed to choose which type to create.

=head2 $configurator->edit($object)

Edits the object C<$object>.  C<$object> must be a Moose object.

=head1 ATTRIBUTES

The details of configuration are up to the configurator implementation, but
it should follow the following guidelines based on what is set on an attribute:

=head2 is

Should be used to lock configuration options in edit.

=head2 isa

Should be used to display different entry elements.

=head2 does

Ignored for now.

=head2 required

Marks the field as required in create.

=head2 builder

Not handled; should fail it used.

=head2 default

Used to show default values in create.

=head2 documentation

Used to display tooltips.

=head2 init_arg

If undef, the default value is shown in an entry field
but is disabled.

=head2 config

Denotes an attribute as configurable.

=head2 section

Denotes which configuration section an attribute should
be in.

=head2 label

The label for the value entry field.

=head2 index

The index at which the attribute's entry field should appear.

=head1 TYPES

I have to decide how to display different entry fields for
different types.

=over

=item Str

=item Int

=item ArrayRef

=item HashRef

=item Bool

=item enum

=item Something Moosey?

=back

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
