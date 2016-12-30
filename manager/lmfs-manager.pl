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
use Filesys::DfPortable;

set logger => 'console';

my $conf = Config::Main->initialize;

get '/' => sub  {
                $conf->greeting;
};

get '/get-file' => sub  {
                $conf->greeting;
                #check hash or return error
                #get from db or return error
                #return
};

post '/upload' => sub {
    my $json_object = from_json(request->body, config->{'engines'}->{'JSON'});
    #get servers from cache
    #push on server
    #update file cache,
    #Return succsess or rro
    my $response = Dancer::Response->new(
            status  => 500,
            content => 'Error',
    );
    return $response;

};



get '/list-nodes' => sub {
    # return list nodes
    my $response = Dancer::Response->new(
            status  => 500,
            content => 'Error',
    );
    return $response;
};


get '/:filename' => sub {
    send_file( $conf->save_dir . "/" . params->{filename}, system_path => 1 );
};


dance;
