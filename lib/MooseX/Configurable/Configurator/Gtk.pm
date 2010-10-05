package MooseX::Configurable::Configurator::Gtk;

use feature 'switch';
use Carp qw(croak);
use Glib qw/TRUE FALSE/;
use Gtk2 '-init';
use Moose;
use namespace::clean -except => 'meta';

our $VERSION = '0.01';

with 'MooseX::Configurable::Role::Configurator';

sub create_section_box {
    my ( $self, $instance, $attributes, $entries ) = @_;
    my $box = Gtk2::VBox->new(TRUE);

    foreach my $attr (@$attributes) {
        my $subbox   = Gtk2::HBox->new(TRUE);
        my $required = $attr->is_required ? ' *' : '';
        my $label    = Gtk2::Label->new($attr->label . $required);

        my $entry;
        if($attr->has_type_constraint) {
            my $type  = $attr->type_constraint->name;
            given($type) {
                when('Str') {
                    $entry = Gtk2::Entry->new;
                }
                when('Int') {
                    my $adj = Gtk2::Adjustment->new(0, -1_000_000_000, 1_000_000_000, 1, 10, 10);
                    $entry = Gtk2::SpinButton->new($adj, 1, 0);
                }
                default {
                    croak "Invalid type";
                }
            }
        } else {
            $entry = Gtk2::Entry->new;
        }

        $subbox->pack_start($label, 1, 0, 0);
        $subbox->pack_end($entry, 1, 0, 0);
        $box->add($subbox);

        my $default = $attr->default($instance);
        if(defined $default) {
            $entry->set_text('' . $default);
        }
        if(defined $attr->init_arg) {
            $entries->{$attr->init_arg} = $entry;
        } else {
            $entry->set_editable(FALSE);
        }
        if(defined $attr->documentation) {
            $entry->set_tooltip_text($attr->documentation);
            $label->set_tooltip_text($attr->documentation);
        }
    }
    $box->add(Gtk2::Label->new('Fields marked with * are required'));

    return $box;
}

sub create {
    my ( $self, $type ) = @_;

    if(ref($type) eq 'ARRAY') {
        croak "Array types unimplemented";
    }

    my $meta = Class::MOP::get_metaclass_by_name($type);
    my @attributes = $meta->get_all_attributes;
    @attributes = grep { $_->config } @attributes;
    my %attrs_by_section;

    @attributes = sort {
        my $cmp = $a->index <=> $b->index;
        $cmp = $a->label cmp $b->label if $cmp == 0;
        $cmp
    } @attributes;

    foreach my $attr (@attributes) {
        my $attrs = ($attrs_by_section{$attr->section} ||= []);
        push @$attrs, $attr;
    }

    my $instance = $meta->get_meta_instance->create_instance;

    my $window = Gtk2::Window->new('toplevel');
    $window->set_title("Create $type");

    my $main_box = Gtk2::VBox->new(FALSE);
    $window->add($main_box);

    my %entries;

    if(keys(%attrs_by_section) == 1) {
        my $box = $self->create_section_box($instance, values %attrs_by_section, \%entries);
        $main_box->pack_start($box, TRUE, TRUE, 0);
    } else {
        my $sections = $meta->section_ordering;
        unless($sections) {
            $sections = $self->default_section_ordering(@attributes);
        }
        my $notebook = Gtk2::Notebook->new;
        $main_box->pack_start($notebook, TRUE, TRUE, 0);

        foreach my $section (@$sections) {
            my $attrs = $attrs_by_section{$section};
            if($attrs) {
                my $box = $self->create_section_box($instance, $attrs, \%entries);
                $notebook->append_page($box, $section);
            }
        }
    }
    my $button_box = Gtk2::HBox->new(FALSE);
    $main_box->pack_end($button_box, FALSE, FALSE, 0);
    my $create_button = Gtk2::Button->new('Create');
    my $cancel_button = Gtk2::Button->new('Cancel');
    my $filler = Gtk2::Label->new('');
    $button_box->pack_start($filler, TRUE, TRUE, 0);
    $button_box->pack_start($create_button, FALSE, FALSE, 0);
    $button_box->pack_end($cancel_button, FALSE, FALSE, 0);

    $window->show_all;
    my $object;
    $window->signal_connect(destroy => sub {
        Gtk2->main_quit;
    });
    $create_button->signal_connect(clicked => sub {
        foreach my $k (keys %entries) {
            my $text = $entries{$k}->get_text;

            unless($text eq '') {
                $entries{$k} = $text;
            } else {
                delete $entries{$k};
            }

        }
        $object = $type->new(%entries);
        Gtk2->main_quit;
    });
    $cancel_button->signal_connect(clicked => sub {
        Gtk2->main_quit;
    });

    Gtk2->main;

    return $object;
}

sub edit {
    my ( $self, $object ) = @_;

    croak "Not yet implemented";
}

1;

__END__

=head1 NAME

MooseX::Configurable::Configurator::Gtk - Gtk configurator

=head1 VERSION

0.01

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

C<MooseX::Configurable>
C<MooseX::Configurable::Role::Configurator>

=cut
