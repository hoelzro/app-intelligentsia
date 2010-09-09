package App::Intelligentsia::ConfigHelper;

use strict;
use warnings;

our $VERSION = '0.01';

use Moose ();
use Moose::Exporter;

use App::Intelligentsia::Config::MetaClass;

Moose::Exporter->setup_import_methods(
    with_meta => [qw/has_config/],
    also => 'Moose',
);

sub _gen_trigger {
    my ( $field, $default ) = @_;

    return sub {
        my ( $self, $new ) = @_;

        unless(defined $new) {
            my $value = $default;
            $value = &$value if ref($value) eq 'CODE';
            $self->$field($value);
        }
    };
}

sub has_config {
    my $meta = shift;
    my $name = shift;
    my %options;

    if(@_ == 1) {
        %options = (default => $_[0]);
    } else {
        %options = @_;
    }
    my $default = $options{'default'};

    $options{'is'} //= 'rw';
    if(exists $options{'isa'}) {
        unless($options{'isa'} =~ /^Maybe\[.*\]$/) {
            $options{'isa'} = 'Maybe[' . $options{'isa'} . ']';
        }
    } else {
        $options{'isa'} = 'Maybe[Str]';
    }
    $options{'trigger'} = _gen_trigger($name, $default) if defined $default;
    $options{'config_attr'} = 1;

    $meta->add_attribute($name, %options);
}

sub init_meta {
    shift;

    return Moose->init_meta(
        @_,
        metaclass => 'App::Intelligentsia::Config::MetaClass',
    );
}

1;

__END__

=head1 NAME

App::Intelligentsia::ConfigHelper

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
