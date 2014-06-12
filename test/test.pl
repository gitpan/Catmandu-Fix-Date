#!/usr/bin/env perl
use Catmandu::Sane;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::Fix;
use Data::Dumper;

my $fixer = Catmandu::Fix->new(fixes => ["datetime_format('my.date.\$first','source_pattern' => '%Y-%m-%dT%H:%M:%SZ','destination_pattern' => '%Y-%m-%d','time_zone' => 'UTC','set_time_zone' => 'Europe/Brussels','default' => '2014-01-01','delete' => 1)"],tidy => 1);

say $fixer->emit;

my $records = [
  { my => { date => [''] } },
  { my => { date => [undef] }},
  { my => { date => ['2014-01-32T00:00:00Z'] } },
  { my => { date => ['2014-03-20T00:00:00Z'] } },
  {
    my => { date => ['200602010000000.0'] }
  }
];

$records = $fixer->fix($records);
print Dumper($records);

