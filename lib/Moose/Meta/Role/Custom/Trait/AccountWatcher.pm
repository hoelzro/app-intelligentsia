package Moose::Meta::Role::Custom::Trait::AccountWatcher;

use Moose::Role;

use App::Intelligentsia::Account;

before apply => sub {
    my ( $self, $target, %options ) = @_;

    if($target->isa('Moose::Meta::Class')) {
        App::Intelligentsia::Account->register_type($target->name, %options);
    }
};

no Moose::Role;

1;
