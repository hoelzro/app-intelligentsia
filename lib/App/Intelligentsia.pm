package App::Intelligentsia;

use strict;
use warnings;

our $VERSION = '0.01';

# ABSTRACT: A graphical Identica/Twitter client

=head1 NAME

App::Intelligentsia

=head1 VERSION

0.01

=head1 SYNOPSIS

use App::Intelligentsia;

App::Intelligentsia->run;

=head1 DESCRIPTION

Intelligentsia is a client for Identica and Twitter.

=head1 METHODS

=head2 App::Intelligentsia->run

Runs the Intelligentsia application.

=cut

sub load_config {
}

sub setup_ui {

}

sub setup_sources {

}

sub run {
    load_config;
    setup_ui;
    setup_sources;
    
    $cond->wait;
}

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

1;
