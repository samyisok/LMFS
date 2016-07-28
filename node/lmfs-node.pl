#!/usr/bin/env perl 
#===============================================================================
#         FILE: lmfs-node.pl
#        USAGE: ./lmfs-node.pl  
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
#      CREATED: 07/27/16 13:23:43
#===============================================================================

use strict;
use warnings;
use utf8;
use Dancer;
use YAML;
use Config::Main;
use Data::Dumper;

my $conf = Config::Main->initialize;

get '/' => sub  {
                $conf->greeting;
                };

post '/upload' => sub {
    my %allparams = params;
    warn Dumper(\%allparams);
    my $json_object = from_json(request->body, config->{'engines'}->{'JSON'});
    warn Dumper($json_object);
    return 200;
};
 
get '/:filename' => sub {
    send_file( $conf->save_dir . "/" . params->{filename}, system_path => 1 );
};

dance;
