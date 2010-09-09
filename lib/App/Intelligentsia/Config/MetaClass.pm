package App::Intelligentsia::Config::MetaClass;

use Moose;
extends 'Moose::Meta::Class';

our $VERSION = '0.01';

sub get_config_attribute_list {
    my ( $self ) = @_;

    my @attrs;

    foreach my $name ($self->get_attribute_list) {
        my $attr = $self->get_attribute($name);
        push @attrs, $name if $attr->does('App::Intelligentsia::Config::Attribute') && $attr->config_attr;
    }
    return @attrs;
}

around add_attribute => sub {
    my $orig = shift;
    my $self = shift;
    my $name = shift;

    my $params;
    if(@_ == 1) {
        $params = shift;
    } else {
        my %params = @_;
        $params = \%params;
    }
    my $traits = ($params->{'traits'} ||= []);
    push @$traits, 'ConfigAttribute';

    @_ = ( $self, $name, $params );
    goto &$orig;
};

1;

__END__

=head1 NAME

App::Intelligentsia::Config::MetaClass

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
