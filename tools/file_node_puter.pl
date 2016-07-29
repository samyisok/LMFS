#!/usr/bin/env perl 
#===============================================================================
#         FILE: file_node_puter.pl
#  DESCRIPTION: 
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
#      CREATED: 07/28/16 19:01:53
#===============================================================================

use strict;
use warnings;
use utf8;
use LWP;
use HTTP::Request;
use Getopt::Long qw(GetOptions);
use Digest::SHA1 qw(sha1_hex);
use JSON;

my $file;
my $api_addr;
my $key;
my $example_message = "example './file_node_puter.pl --file dummy.png --api http://0.0.0.0:3000/upload --key <key>'  \n";

GetOptions(
          'file=s'   => \$file,
          'api=s'  => \$api_addr,
          'key=s' => \$key,
) or die($example_message);
die($example_message) if !$file or !$api_addr;

open(my $fh, '<', $file) or die 'can not open file';
my $file_content;
{
    local $/ = undef  ;
    $file_content = <$fh>;
}
close $fh;

my $file_sha1 = sha1_hex($file_content);
my $file_size = length($file_content);

my $file_json = JSON->new->utf8->encode({ 
                                    name => $file,
                                    sha1 => $file_sha1,
                                    size => $file_size,
                                    file => $file_content,
                                    key => $key,
                                                     });


my $req = HTTP::Request->new( 'POST', $api_addr );
$req->header( 'Content-Type' => 'application/json' );
$req->content( $file_json );

my $lwp = LWP::UserAgent->new;
my $response = $lwp->request( $req );

if ( $response->is_success ) {
    print "everything is ok" . "\n Status: " . $response->status_line;
}
else {
    print "something going wrong" . "\n Status: " . $response->status_line;
}



