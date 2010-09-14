package App::Intelligentsia::Config;

use App::Intelligentsia::ConfigHelper;
use feature 'switch';

our $VERSION = '0.01';

use Carp qw(carp croak);
use File::Spec::Functions qw(catfile);
use IO::File;
use Moose::Util::TypeConstraints qw(class_type);
use Scalar::Util qw(reftype);
use YAML qw(Dump Load);

class_type Config => {
    class => __PACKAGE__,
};

sub _set_config {
    my ( $values, $k, $v ) = @_;
    my $meta = __PACKAGE__->meta;

    if($meta->has_attribute($k) && $meta->get_attribute($k)->config_attr) {
        $values->{$k} = $v;
    } else {
        carp "No such configuration variable '$k'";
    }
}

sub _reset_to_defaults {
    my ( $self ) = @_;

    foreach my $attr ($self->meta->get_config_attribute_list) {
        $self->$attr(undef);
    }
}

sub _load_handle {
    my ( $params, $handle ) = @_;

    my $yaml = do {
        local $/;
        <$handle>;
    };
    $yaml = Load($yaml);

    while(my ( $k, $v ) = each %$yaml) {
        _set_config($params, $k, $v);
    }
}

use namespace::clean;

has filename => (
    is => 'rw',
    isa => 'Maybe[Str]',
    default => sub {
        my $home = (getpwuid $<)[7];
        return catfile($home, '.intelligentsiarc');
    },
);

has_config ui => 'Gtk';
has_config accounts => (
    isa => 'Maybe[ArrayRef[HashRef]]',
    default => sub { [] },
);

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;

    my %build_args;
    my $values;
    
    given(scalar(@_)) {
        when(0) {
            # no-op
        }
        when(1) {
            my $filename_or_values = shift;

            if(ref($filename_or_values)) {
                $values = $filename_or_values;
                $build_args{'filename'} = undef;
            } else {
                $build_args{'filename'} = $filename_or_values;
            }
        }
        when(2) {
            $build_args{'filename'} = shift;
            $values = shift;
        }
        default {
            croak "Too many arguments to App::Intelligentsia::Config::new";
        }
    }

    my $params = $class->$orig(%build_args);
    if($values) {
        given(ref $values) {
            when('HASH') {
                while(my ( $k, $v ) = each %$values) {
                    _set_config($params, $k, $v);
                }
            }
            when('ARRAY') {
                for(my $i = 0; $i < @$values; $i += 2) {
                    my ( $k, $v ) = @{$values}[$i, $i + 1];
                    _set_config($params, $k, $v);
                }
            }
            default {
                if(reftype($values) eq 'GLOB') {
                    _load_handle($params, $values);
                } else {
                    croak "Invalid value provided to App::Intelligentsia::Config::new (must be a HASH, ARRAY, GLOB, or IO::Handle)";
                }
            }
        }
    }

    return $params;
};

sub load {
    my ( $self, $filename ) = @_;

    my $handle;

    if(defined $filename) {
        if(reftype($filename) eq 'GLOB') {
            $handle = $filename;
            $self->filename(undef);
        } else {
            $self->filename($filename);
        }
    } else {
        $filename = $self->filename;
        unless(defined $filename) {
            croak "No default filename has been specified";
        }
    }

    unless($handle) {
        if(-e $filename) {
            $handle = IO::File->new($filename, '<') || croak "Cannot load $filename: $!";
        }
    }

    if($handle) {
        my $values = {};
        _load_handle($values, $handle);

        _reset_to_defaults($self);
        while(my ( $k, $v ) = each %$values) {
            $self->$k($v);
        }
    }
}

sub save {
    my ( $self, $filename ) = @_;

    my $handle;

    if(defined $filename) {
        if(reftype($filename) eq 'GLOB') {
            $handle = $filename;
            $self->filename(undef);
        } else {
            $self->filename($filename);
        }
    } else {
        $filename = $self->filename;
        unless(defined $filename) {
            croak "No default filename has been specified";
        }
    }

    unless($handle) {
        $handle = IO::File->new($filename, '>') || croak "Cannot save $filename: $!";
    }

    my %config;
    my $meta = $self->meta;
    foreach my $attr ($meta->get_config_attribute_list) {
        $config{$attr} = $self->$attr();
    }

    my $yaml = Dump(\%config);
    print $handle Dump(\%config);
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

App::Intelligentsia::Config

=head1 VERSION

0.01

=head1 SYNOPSIS

  use feature 'say';
  use App::Intelligentsia::Config;

  my $config = App::Intelligentsia::Config->new;
  $config->load;
  say $config->ui;
  $config->ui('Gtk');
  $config->save;

=head1 DESCRIPTION

App::Intelligentsia::Config handles the duties of loading configurations
from a file, accessing them (and their defaults), and saving them back to
disk.  All load/save operations treat the file data as YAML.

=head1 METHODS

=head2 App::Intelligentsia::Config->new

=head2 App::Intelligentsia::Config->new($filename)

=head2 App::Intelligentsia::Config->new($values)

=head2 App::Intelligentsia::Config->new($filename => $values)

Creates a new C<App::Intelligentsia::Config> object.  If C<$filename> is provided,
that file upon which L</load> and L</save> will operate by default.  If C<$values> is
provided, the configuration's values are taken from that value.  If C<$filename> is
specified and C<$values> is not, C<$self-E<gt>load> is automatically called.

The way the configuration is initialized by C<$values> depends on what it contains:

=head3 Array Reference

If C<$values> is an array reference, it is treated as a list of key-value pairs, like this:

  $values = [foo => 1, bar => 2]

=head3 Hash Reference

If C<$values> is a hash reference, its keys and values are used to initialize the configuration.

=head3 Glob Reference

=head3 L<IO::Handle>

If C<$values> is a glob reference or an IO::Handle, the configuration is loaded from that handle.

=head2 $config->load([$filename]);

Clears the current configuration, and loads a new set of values from C<$filename>.  If C<$filename> not provided,
it defaults to the current default filename.  If C<$filename> is provided and is a string, the default filename to
use is set to C<$filename> and the configuration is loaded from that file.  If C<$filename> is a glob reference or
an L<IO::Handle>, its contents are loaded, but the default filename to use is set to C<undef>.

=head2 $config->save([$filename]);

Saves the current configuration to C<$filename>.  If C<$filename> is not provided, it defaults to the current
default filename.  If C<$filename> is provided and is a string, the default filename to use is set to C<$filename>
and the configuration is saved to that file.  If C<$filename> is a glob reference or an L<IO::Handle>, the configuration
is written to that handle, but the default filename to use is set to C<undef>.

=head2 $config->filename

Returns the current default filename to use for L</load> and L</save>.  Defaults to C<$HOME/.intelligentsiarc>.

=head2 $config->filename([$filename])

Sets the current default filename to use for L</load> and L</save>.  If set to C<undef>, argument-less load/save
will raise an error.

=head2 $config->FIELD

Returns the configuration value for C<FIELD>.

=head2 $config->FIELD($value)

Sets the configuration value for C<FIELD> to C<$value>.  If C<$value> is C<undef>, it is set to the default.

=head1 CONFIGURATION VALUES

=head2 ui

The UI implementation to use.  Defaults to 'Gtk'.

=head2 accounts

The list of account configurations. Defaults to [].

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

L<App::Intelligentsia>

=cut
