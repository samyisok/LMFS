package Lib::Db::Schema::Result::Server;

use strict;
use warnings;
use utf8;


use base 'DBIx::Class::Core';

__PACKAGE__->table('servers');
__PACKAGE__->add_columns( qw/
  name
  host
/);

__PACKAGE__->set_primary_key('name');

1;
