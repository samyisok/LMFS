#
#===============================================================================
#
#         FILE: config.t
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Sergey Magochkin (), magaster@gmail.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 07/27/16 14:40:54
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use FindBin;
use utf8;
use lib "$FindBin::Bin/..";
use Test::More tests => 2;                      # last test to print
use Config::Main;
use Try::Tiny;

subtest 'load' => sub {
    my $args = { params => 'string 1' };
    my $config = Config::Main->initialize($args);
    my $correct_vars = { key => '1231234qeqwedasw2e24234',
                         save_dir => '/tmp/dir1',
                         greeting => 'i greet you',
                        };
    ok( $config, "successful create object, ok");
    ok( $config->key eq $correct_vars->{key}, "read key in config is correct, ok");
    ok( $config->save_dir eq $correct_vars->{save_dir}, "read save_dir in config is correct, ok");
    ok( $config->greeting eq $correct_vars->{greeting}, "read greeting in config is correct, ok");

    my $config2 = Config::Main->instance;
    ok( $config2->params eq $args->{params}, "is singleton, ok" );
};

subtest 'custom_path' => sub {
    my $custom_path = 'ini/config2.yml';
    my $args = { custom_path => $custom_path };
    my $correct_vars = { key => 'AnotherKey' };
    Config::Main->_clear_instance;
    my $config = Config::Main->initialize($args);
    ok( $config->key eq $correct_vars->{key}, "read key in config is correct, ok");

};


