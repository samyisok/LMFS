#===============================================================================
#         FILE: List.pm
#  DESCRIPTION: Logic for get all files 
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
#      CREATED: 12/27/16 18:03:37
#===============================================================================
package Lib::File::List;

use strict;
use warnings;
use utf8;
use Moose;
use JSON;
use FindBin;
use lib "$FindBin::Bin/../../";
use Config::Main;

sub get_all {
    my $self = shift;

    my $conf = Config::Main->instance;
    my $rs = $conf->schema->resultset('File')->search({});

    my @data;
    if ($rs){
        for my $row ($rs->all){
            push @data, {
                name => $row->name,
                sha1 => $row->sha1,
            }
        }
    }

    return to_json(\@data);
}


1;
