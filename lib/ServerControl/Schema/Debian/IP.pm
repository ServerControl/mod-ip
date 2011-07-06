#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package ServerControl::Schema::Debian::IP;

use strict;
use warnings;

use ServerControl::Schema;
use base qw(ServerControl::Schema::Module);

__PACKAGE__->register(
   
      'ip'           => '/sbin/ip',

);

1;
