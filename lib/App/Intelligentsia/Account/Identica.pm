package App::Intelligentsia::Account::Identica;

use Moose;

use namespace::clean;

extends 'App::Intelligentsia::Account::StatusNet';

# we need this so that it gets registered as
# an account type
with 'App::Intelligentsia::Account';

our $VERSION = '0.01';

## can we make it so these can't be overriden
## in the constructor?
has '+api_url' => (
    required => 0,
    default => 'http://identi.ca/api',
);

has '+api_host' => (
    required => 0,
    default => 'identi.ca:80',
);

has '+api_realm' => (
    required => 0,
    default => 'Laconica API',
);

1;

__END__

=head1 NAME

App::Intelligentsia::Account::Identica

=head1 VERSION

0.01

=head1 SYNOPSIS

  use App::Intelligentsia::Account;

  my $account = App::Intelligentsia::Account->create(
    type => 'Identica',
    username => $username,
    password => $password,
  );

=head1 DESCRIPTION

An account class that handles receiving messages from an
Identi.ca account.

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
C<App::Intelligentsia::Account>
C<App::Intelligentsia::Account::StatusNet>

=cut
