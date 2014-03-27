package Catmandu::Fix::datetime_format;
use Catmandu::Sane;
use Moo;
use Catmandu::Util qw(:is :check);
use DateTime::Format::Strptime;
use DateTime::TimeZone;
use DateTime;

has source => (
  is => 'ro' , 
  required => 1
);
has locale => (
  is => 'ro',
  required => 1,
  isa => sub {
    check_string($_[0]);
  },
  default => sub {
    "en_EN"
  }
);
has time_zone => (
  is => 'ro',
  required => 1,
  isa => sub {
    check_string($_[0]);
  },
  default => sub {
    "local"
  }
);
has set_time_zone => (
  is => 'ro',
  required => 1,
  isa => sub {
    check_string($_[0]);
  },
  default => sub {
    "local"
  }
);

has source_pattern => (
  is => 'ro',

  required => 1,
  isa => sub {
    check_string($_[0]);
  },
  default => sub {
    "%s"
  }
);
has destination_pattern => (
  is => 'ro',
  required => 1,
  isa => sub {
    check_string($_[0]);
  },
  default => sub {
    "%FT%T.%NZ"
  }
);
around BUILDARGS => sub {
  my($orig,$class,$source,%args) = @_;

  $orig->($class,
    source => $source,
    %args
  );
};

sub emit {
  my($self,$fixer) = @_;

  my $perl = "";  

  my $source = $fixer->split_path($self->source());
  my $skey = pop @$source;

  my $value = $fixer->generate_var();
  $perl .= $fixer->emit_declare_vars($value);

  my $set_time_zone = $fixer->generate_var();
  $perl .= $fixer->emit_declare_vars($set_time_zone,$fixer->emit_string($self->set_time_zone()));

  my $parser = $fixer->generate_var();
  $perl .= $fixer->emit_declare_vars($parser,"DateTime::Format::Strptime->new(pattern => '".$self->source_pattern."',locale => '".$self->locale."',time_zone => '".$self->time_zone."')");

  $perl .= $fixer->emit_walk_path($fixer->var,$source,sub{
    my $var = shift;
    $fixer->emit_get_key($var,$skey, sub {
      my $var = shift;
      my $d = $fixer->generate_var();

      my $p = "if(is_string($var)){";
      $p .= $fixer->emit_declare_vars($d);
      $p .= " $d = ".${parser}."->parse_datetime($var);";
      $p .= " $d->set_time_zone(${set_time_zone});";
      $p .= " if($d){";    
      $p .= "   $value = DateTime::Format::Strptime::strftime('".$self->destination_pattern()."',$d);";    
      $p .= " }";
      $p .= "${var} = ${value};";
      $p .="}";
      $p;
    });
  });

  $perl;
}

=head1 NAME

  Catmandu::Fix::datetime_format

=head1 SYNOPSIS

  datetime_format('timestamp','source_pattern' => '%s','destination_pattern' => '%Y-%m-%d','time_zone' => 'UTC','set_time_zone' => 'Europe/Brussels')

=head1 SEE ALSO

L<Catmandu::Fix>

=cut

1;
