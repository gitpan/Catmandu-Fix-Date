use warnings;
use strict;
use Module::Build;

my $requires = {
  perl => '5.10.1',
  Catmandu => 0,  
  'Moo' => 0,
  'DateTime' => 0,
  'DateTime::Format::Strptime' => 0,
  'DateTime::TimeZone' => 0,
  'Time::HiRes' => 0
};
my $recommends = {};

my $build = Module::Build->new(
  module_name => 'Catmandu-Fix-Date',
  dist_version_from => 'lib/Catmandu/Fix/Date.pm',  
  dist_author => [qw(
    nicolas.franck@ugent.be
  )],
  dist_abstract => 'Catmandu fix modules for parsing dates',
  requires => $requires,
  recommends => $recommends,
  license => 'perl',
  create_license => 1,
  create_makefile_pl => 'traditional'
);
$build->create_build_script();
