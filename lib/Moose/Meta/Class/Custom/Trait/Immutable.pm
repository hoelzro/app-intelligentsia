package Moose::Meta::Class::Custom::Trait::Immutable;

use Carp qw(croak);
use Moose::Role;

use namespace::clean;

our $VERSION = '0.01';

around add_attribute => sub {
    my $orig = shift;
    my $self = shift;
    my $name = shift;

    my $params;

    if(@_ == 1) {
        $params = $_[0];
    } else {
        $params = { @_ };
    }

    if(exists $params->{'is'} && $params->{'is'} ne 'ro') {
        croak "Attempt to create non-readonly attribute '$name'";
    }
    $params->{'is'} = 'ro';

    $self->$orig($name, $params);
};

1;

__END__

=head1 NAME

Moose::Meta::Class::Custom::Trait::Immutable

=head1 VERSION

0.01

=head1 SYNOPSIS

  use Moose -traits => ['Immutable'];

=head1 DESCRIPTION

=head1 FUNCTIONS

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
