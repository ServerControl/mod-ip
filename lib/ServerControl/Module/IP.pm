#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package ServerControl::Module::IP;

use strict;
use warnings;

use ServerControl::Module;
use ServerControl::Commons::Process;

use base qw(ServerControl::Module);

our $VERSION = '0.93';

use Data::Dumper;

__PACKAGE__->Parameter(
   help  => { isa => 'bool', call => sub { __PACKAGE__->help; } },
);

sub help {
   my ($class) = @_;

   print __PACKAGE__ . " " . $ServerControl::Module::IP::VERSION . "\n";

   printf "  %-20s%s\n", "--path=", "The path where the instance should be created";
   printf "  %-20s%s\n", "--ip=", "IP";
   printf "  %-20s%s\n", "--netmask=", "Netmask";
   printf "  %-20s%s\n", "--broadcast=", "Broadcast";
   printf "  %-20s%s\n", "--dev=", "On which device sould the ip be bound";
   print "\n";
   printf "  %-20s%s\n", "--create", "Create the instance";
   printf "  %-20s%s\n", "--start", "Start the instance";
   printf "  %-20s%s\n", "--stop", "Stop the instance";

}

sub start {
   my ($class) = @_;

   my ($name, $path) = ($class->get_name, $class->get_path);
   my $args = ServerControl::Args->get;

   my $ip = ServerControl::Schema->get("ip");

   my $cmd = "$ip addr add " . $args->{"ip"};
   if($args->{"netmask"}) {
      $cmd .= "/".$args->{"netmask"};
   }
   if($args->{"broadcast"}) {
      $cmd .= " broadcast " . $args->{"broadcast"};
   }

   unless($args->{"dev"}) {
      die("No dev specified.");
   }

   $cmd .= " dev " . $args->{"dev"};

   spawn("$cmd");
}

sub stop {
   my ($class) = @_;

   my ($name, $path) = ($class->get_name, $class->get_path);
   my $args = ServerControl::Args->get;

   my $cmd = "ip addr del " . $args->{"ip"};
   if($args->{"netmask"}) {
      $cmd .= "/".$args->{"netmask"};
   }
   if($args->{"broadcast"}) {
      $cmd .= " broadcast " . $args->{"broadcast"};
   }

   unless($args->{"dev"}) {
      die("No dev specified.");
   }

   $cmd .= " dev " . $args->{"dev"};

   spawn("$cmd");
}

sub restart {

   $_[0]->stop;
   $_[0]->start;

}

sub status {
   my ($class) = @_;

   my ($name, $path) = ($class->get_name, $class->get_path);
   my $args = ServerControl::Args->get;

   unless($args->{"dev"}) {
      die("No dev specified.");
   }

   my $cmd = "ip a s ".$args->{"dev"}." | grep -q ".$args->{"ip"};

   spawn("$cmd");
   
   if ($? == 0) { 
     return 1;
   } 

   return 0;

}


