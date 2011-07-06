use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'ServerControl-IP',
   VERSION_FROM => 'lib/ServerControl/Module/IP.pm',
   PREREQ_PM => {'ServerControl' => '0.90'},
   LICENSE => 'bsd'
);

