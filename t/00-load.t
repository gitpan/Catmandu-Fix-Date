#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

my @packages = qw(
  Catmandu::Fix::Date
  Catmandu::Fix::datetime_format
  Catmandu::Fix::timestamp
);

for(@packages){
  use_ok($_);
}

done_testing scalar(@packages);
