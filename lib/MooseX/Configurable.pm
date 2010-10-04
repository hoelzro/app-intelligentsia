package MooseX::Configurable;

use Moose ();
use Moose::Exporter;

our $VERSION = '0.01';

sub section_ordering {
    my ( $meta, @sections ) = @_;

    $meta->section_ordering(\@sections);
}

Moose::Exporter->setup_import_methods(
    with_meta => [qw/section_ordering/],
    base_class_roles => ['MooseX::Configurable::Role::Configurable'],
    class_metaroles => {
        class     => ['MooseX::Configurable::Trait::HasSections'],
        attribute => ['MooseX::Configurable::Trait::ConfigAttribute'],
    },
);

1;

__END__

=head1 NAME

MooseX::Configurable

=head1 VERSION

0.01

=head1 SYNOPSIS

  use Moose;
  use MooseX::Configurable;

  has my_field => (
    config => 1,
    section => 'General',
    index => 0,
    label => 'My Field',
    is => 'rw',
    isa => 'Str',
    required => 1,
    documentation => 'This field needs to be set',
  );

  section_ordering 'General', 'Other';

=head1 DESCRIPTION

Allows you to make your classes easily creatable and configurable via a
GUI interface.

MooseX::Configurable adds 4 extra parameters to C<has>, as well as an extra
sugar function C<section_ordering>.

=over 4

=item config

A boolean value that specifies whether or not this attribute is configurable.
Defaults to false.

=item section

A string value that specifies which configuration section this attribute's
control should be present in.  How to present these sections (or whether to
present them at all) is up to the configurator.  Defaults to 'General'.

=item index

The index at which this attribute's control should be within its configuration
section.  It is entirely up to the configurator to obey this setting or not.
Defaults to 0.

=item label

The label to display next to this attribute's control.  The default takes the
name and splits it into title case words as best as it can figure out.

=item section_ordering

Specifies what order the configurator should display the configuration sections
in.  Defaults to 'General', then the rest of the section in lexicographical
order.

=back

=head1 AUTHOR

Rob Hoelz, C<< rob at hoelz.ro >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-MooseX-Configurable at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Configurable>. I will
be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2010 Rob Hoelz.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

C<MooseX::Configurable::Role::Configurator>

=cut
