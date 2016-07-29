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
use Lib::File::Save;

set logger => 'console';

my $conf = Config::Main->initialize;

get '/' => sub  {
                $conf->greeting;
                };

post '/upload' => sub {
    my $json_object = from_json(request->body, config->{'engines'}->{'JSON'});
    my $success = Lib::File::Save->save($json_object);
    my $response;
    if ( $success ){
        $response = Dancer::Response->new(
            status  => 200,
            content => 'ok',
        );
    }
    else {
        $response = Dancer::Response->new(
            status  => 501,
            content => 'Error',
        );
    }
    return $response;
};
 
get '/:filename' => sub {
    send_file( $conf->save_dir . "/" . params->{filename}, system_path => 1 );
};

dance;
