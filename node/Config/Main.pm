
#===============================================================================
#         FILE: Main.pm
#  DESCRIPTION: 
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
#      CREATED: 07/27/16 13:36:01
#===============================================================================

package Config::Main;

use utf8;
use strict;
use warnings;
use MooseX::Singleton;
use Readonly;
use Carp;
use YAML::Tiny;
use 5.018;
use FindBin;
use lib "$FindBin::Bin/..";
use Lib::Db::Schema;
use File::Path qw( make_path );

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

has 'dbuser' => (
    is => 'ro',
    isa => 'Str',
    writer => 'set_dbuser',
);

has 'dbpass' => (
    is => 'ro',
    isa => 'Str',
    writer => 'set_dbpass',
);

has 'dbpref' => (
    is => 'ro',
    isa => 'Str',
    writer => 'set_dbpref',
);

has 'schema' => (
    is => 'ro',
    isa => 'Object',
    writer => 'set_schema',
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
    
    $self->init_save_dir;

    #for normal db
    $self->set_dbuser( $conf->{dbuser} ) if $conf->{dbuser}; 
    $self->set_dbpass( $conf->{dbpass} ) if $conf->{dbpass}; 
    
    $self->set_dbpref( $conf->{dbpref} ) or croak "You need DataBase to operate"; 
    my $schema = Lib::Db::Schema->connect($self->dbpref, $self->dbuser, $self->dbpass, { quote_names => 1 });
    $self->set_schema($schema);
    $self->schema->storage->debug(1) if $DEBUG;
    
    return;
}

sub BUILD 
{
    my $self = shift;
    my $args = shift;

    $self->init( $args );
    return;
}

sub init_save_dir {
    my $self = shift;
    make_path($self->save_dir) unless (-e $self->save_dir);
}

1;
