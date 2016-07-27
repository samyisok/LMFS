
#===============================================================================
#
#         FILE: Main.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 07/27/16 13:36:01
#     REVISION: ---
#===============================================================================

package Config::Main;

use strict;
use warnings;
use MooseX::Singleton;
use Readonly;
use Carp;
use YAML::Tiny;
use 5.018;

Readonly my $DEF_CONFIG_NAME => 'config.yml';
Readonly my $DEF_CONFIG_DIR => 'ini';
Readonly my $ERR_CANT_OPEN => 'Can not open file';
Readonly my $DEBUG => 1;

has 'key' => ( 
    is => 'ro',
    isa => 'Str',
    writer => 'set_key',
);

has 'save_dir' => ( 
    is => 'ro',
    isa => 'Str',
    writer => 'set_save_dir',
);

has 'greeting' => ( 
    is => 'ro',
    isa => 'Str',
    writer => 'set_greeting',
);

has 'params' => ( 
    is => 'rw',
    isa => 'Str',
    writer => 'set_params',
);


sub init 
{
    my $self = shift;
    my $args = shift;
    my $params = $args->{params} || '';
    my $default_path = $DEF_CONFIG_DIR . "/" . $DEF_CONFIG_NAME;
    my $path_to_config = $args->{custom_path} || $default_path;
    my $conf = YAML::Tiny->read($path_to_config)->[0] or ( $DEBUG ? confess : croak $ERR_CANT_OPEN );

    $self->set_params( $params ) if $params;
    $self->set_key( $conf->{key} ) or croak "You need secret key for operate";
    $self->set_save_dir( $conf->{save_dir} ) or croak "You need folder for files for operate"; 
    $self->set_greeting( $conf->{greeting} ) if $conf->{greeting}; 

    return;
}

sub BUILD 
{
    my $self = shift;
    my $args = shift;

    $self->init( $args );
    return;
}



1;
