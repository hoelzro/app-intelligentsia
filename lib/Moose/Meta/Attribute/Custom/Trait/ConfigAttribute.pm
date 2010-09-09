package Moose::Meta::Attribute::Custom::Trait::ConfigAttribute;

use strict;
use warnings;

our $VERSION = '0.01';

sub register_implementation {
    return 'App::Intelligentsia::Config::Attribute';
}

1;

__END__

=head1 NAME

Moose::Meta::Attribute::Custom::Trait::ConfigAttribute

=head1 VERSION

0.01

=head1 SYNOPSIS

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

=cut
