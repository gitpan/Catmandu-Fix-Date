use warnings;
use strict;
use Module::Build;

my $requires = {
  perl => '>=5.10.0',
  Catmandu => 0,  
  'Moo' => 0,
  'DateTime' => 0,
  'DateTime::Format::Strptime' => 0,
  'DateTime::TimeZone' => 0,
  'Time::HiRes' => 0
};
my $recommends = {};

my $build = Module::Build->new(
  module_name => 'catmandu-fix-date',
  dist_version => '0.01',
  dist_author => [qw(
    nicolas.franck@ugent.be
  )],
  dist_abstract => 'Catmandu fix modules for parsing dates',
  requires => $requires,
  recommends => $recommends,
  license => 'perl',
  create_license => 1
);
$build->create_build_script();
