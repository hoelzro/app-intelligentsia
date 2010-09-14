package App::Intelligentsia::Account;

use Moose::Role;

use Carp qw(croak);

use namespace::clean;

our $VERSION = '0.01';

sub create {
    my ( $self, $config ) = @_;

    unless(exists $config->{'type'}) {
        croak "The config option to App::Intelligentsia::Account::create must contain a 'type' field";
    }
    my $type = delete $config->{'type'};
    my $path = "App/Intelligentsia/Account/$type.pm";
    my $class = "App::Intelligentsia::Account::$type";

    eval {
        require $path;
        return $class->new(%$config);
    };
    if($@) {
        croak "Unable to create account of type $type: $@";
    }
}

1;

__END__

=head1 NAME

App::Intelligentsia::Account

=head1 VERSION

0.01

=head1 SYNOPSIS

  use App::Intelligentsia::Account;

  my $account = App::Intelligentsia::Account->create(\%config);

=head1 DESCRIPTION

The Account role is the base role for all types of accounts.  The two ways to
use App::Intelligentsia::Account are to either consume the role, or to use
App::Intelligentsia::Account->create to dynamically create an account object
from a configuration hash.

=head1 METHODS

=head2 App::Intelligentsia::Account->create(\%config)

Creates an account object from C<%config>.  C<%config> should contain a key 'type',
which will create an object of class C<App::Intelligentsia::Account::$type>.  That
class is expected to consume the App::Intelligentsia::Account role.

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
