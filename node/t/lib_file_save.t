#
#===============================================================================
#         FILE: lib_file_save.t
#  DESCRIPTION: 
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
#      CREATED: 07/28/16 23:47:05
#===============================================================================

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/..";
use Config::Main;
use File::Copy;
use Digest::SHA1 qw(sha1_hex);
use Test::More tests => 2;                      # last test to print
use Lib::File::Save;
use Lib::File::List;
use File::Compare;

my $file_name = 'dummy2.png';
my $file_path = 'testfiles' . '/' . $file_name;
my $config_path = "testfiles/test-config.yml";

open(my $fh, '<', $file_path) or die 'can not open file';
my $file_content;
{
    local $/ = undef  ;
    $file_content = <$fh>;
}
close $fh;

my $default_db = 'testfiles/node-default.sqlite';
my $current_db = 'db/node-test.sqlite';
copy($default_db, $current_db) or die "copy failed $!";

my $conf = Config::Main->initialize({custom_path => $config_path});

my $file_sha1 = sha1_hex($file_content);
my $file_size = length($file_content);

my $hash_file = { 
                name => $file_name,
                sha1 => $file_sha1,
                size => $file_size,
                file => $file_content,
                key => $conf->key,
                };

Lib::File::Save->save($hash_file);

my $saved_file_path = $conf->save_dir . '/' . $file_name;

ok(compare($file_path, $saved_file_path) == 0, 'files are equal, saved ok');
my $data = Lib::File::List->get_all();
my $correct_data = qq/[{"sha1":"c16339541bce3a46de7b6c859c2d3ff63bb5f09b","name":"dummy.png"},{"sha1":"3d2f9af24872364476a34ac85b08186ecbccc7cf","name":"dummy2.png"}]/;

ok( $data eq $correct_data, 'get correct json, ok' );

unlink($current_db); 
unlink($saved_file_path); 
