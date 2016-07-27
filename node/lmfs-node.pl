#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: lmfs-node.pl
#
#        USAGE: ./lmfs-node.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 07/27/16 13:23:43
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Dancer;
use YAML;
use Config::Main;

my $conf = Config::Main->initialize;

get '/' => sub  {
                $conf->greeting;
                };

post '/upload' => sub {

};
 
dance;
