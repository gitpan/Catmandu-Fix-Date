
# This file was automatically generated by Dist::Zilla::Plugin::ModuleBuild v5.016.
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Catmandu fixes for processing dates",
  "dist_author" => [
    "Nicolas Franck, C<< <nicolas.franck at ugent.be> >>"
  ],
  "dist_name" => "Catmandu-Fix-Date",
  "dist_version" => "0.0122",
  "license" => "perl",
  "module_name" => "Catmandu::Fix::Date",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Catmandu" => 0,
    "DateTime" => 0,
    "DateTime::Format::Strptime" => 0,
    "DateTime::TimeZone" => 0,
    "Moo" => 0,
    "Time::HiRes" => 0,
    "perl" => "v5.10.1"
  },
  "script_files" => [],
  "test_requires" => {
    "Test::Exception" => 0,
    "Test::More" => 0
  }
);


my %fallback_build_requires = (
  "Module::Build" => "0.3601",
  "Test::Exception" => 0,
  "Test::More" => 0
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  delete $module_build_args{test_requires};
  $module_build_args{build_requires} = \%fallback_build_requires;
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
