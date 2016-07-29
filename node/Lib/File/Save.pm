#
#===============================================================================
#         FILE: Save.pm
#  DESCRIPTION: Logic for save file and how save file
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
#      CREATED: 07/28/16 18:52:37
#===============================================================================
package Lib::File::Save;

use strict;
use warnings;
use utf8;
use Moose;
use json;
use FindBin;
use lib "$FindBin::Bin/../../";
use Config::Main;
use Digest::SHA1 qw(sha1_hex);

sub check_file{
    my $self = shift;
    my $file_content = shift;
    my $file_sha1 = shift;
    my $file_size = shift;
    my $our_size = length($file_content);
    my $our_sha1 = sha1_hex($file_content);
    return 1 if ($our_size == $file_size) and ($our_sha1 eq $file_sha1);
}


sub save {
    my $self = shift;
    my $json_object = shift;
    my $file_size = $json_object->{size};
    my $file_name = $json_object->{name};
    my $file_sha1 = $json_object->{sha1};
    my $file_content = $json_object->{file};

    my $check_file = $self->check_file($file_content, $file_sha1, $file_size);
    warn "checking file" . $check_file;
    return 0 unless $check_file;
    my $conf = Config::Main->instance;
    my $rs = $conf->schema->resultset('File');
    $rs->create({
        name => $file_name,
        sha1 => $file_sha1,
        size => $file_size,
        cdate => time(),
        });
    my $path_to_save = $conf->save_dir . '/' . $file_name;
    open(my $fh, '>', $path_to_save) or die('can not save file');
    {
        local $/ = undef;
        print $fh $file_content;
    }
    close $fh;
    return 1;
}

1;
