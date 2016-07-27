package Lib::Db::Schema::Result::File;

use strict;
use warnings;
use utf8;


use base 'DBIx::Class::Core';

__PACKAGE__->table('files');
__PACKAGE__->add_columns( qw/
  name
  sha1
  cdate
  size
/);

__PACKAGE__->set_primary_key('name');

1;
