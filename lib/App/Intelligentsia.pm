package App::Intelligentsia;

use strict;
use warnings;

our $VERSION = '0.01';

use AnyEvent;
use File::Spec::Functions qw(catfile);
use YAML qw(Load);

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

my $cond;
my $config;

sub load_config {
    my $home = (getpwuid $<)[7];
    my $config_file = catfile($home, '.intelligentsiarc');

    my $fh;
    unless(open $fh, '<', $config_file) {
        if(-e $config_file) {
            die "Fatal Error: $config_file exists, but cannot be read!\n";
        }
        $config = {};
        return;
    }
    my $yaml = do {
        local $/;
        <$fh>
    };
    close $fh;
    eval {
        $config = Load($yaml);
    };
    if($@) {
        die "Fatal Error: $config_file does not contain valid YAML!\n";
    }
    unless(ref($config) eq 'HASH') {
        die "Fatal Error: The top level data structure in $config_file is not a dictionary!\n";
    }
}

sub setup_ui {

}

sub setup_sources {

}

sub run {
    load_config;
    setup_ui;
    setup_sources;

    $cond = AnyEvent->condvar;
    
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
