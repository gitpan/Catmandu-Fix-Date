package Catmandu::Fix::datetime_format;
use Catmandu::Sane;
use Moo;
use Catmandu::Util qw(:is :check :array);
use DateTime::Format::Strptime;
use DateTime::TimeZone;
use DateTime;

our $VERSION = "0.0121";

with 'Catmandu::Fix::Base';

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
has default => ( is => 'ro' );
has delete => ( is => 'ro' );
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
has _datetime_parser => (
  is => 'ro',
  lazy => 1,
  default => sub {
    my $self = $_[0];
    DateTime::Format::Strptime->new(
      pattern => $self->source_pattern, 
      locale => $self->locale,
      time_zone => $self->time_zone,
      on_error => 'undef'
    );
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
  my $key = pop @$source;
  
  my $set_time_zone = $fixer->generate_var();
  $perl .= $fixer->emit_declare_vars($set_time_zone,$fixer->emit_string($self->set_time_zone()));

  my $parser = $fixer->capture($self->_datetime_parser());

  $perl .= $fixer->emit_walk_path($fixer->var,$source,sub{

    my $pvar = shift;

    $fixer->emit_get_key($pvar,$key, sub {

      my $var = shift;
      my $d = $fixer->generate_var();

      my $p =   $fixer->emit_declare_vars($d);
      $p .=   " $d = ".${parser}."->parse_datetime($var);";  
      $p .=   " if($d){";    
      $p .=   "   $d->set_time_zone(${set_time_zone});";
      $p .=   "   ${var} = DateTime::Format::Strptime::strftime('".$self->destination_pattern()."',$d);";          
      $p .=   " }";
      if($self->delete){
        $p .= " else { ".$fixer->emit_delete_key($pvar,$key)." }";
      }elsif(defined($self->default)){
        $p .= " else { ${var} = ".$fixer->emit_string($self->default)."; }";
      }

      $p;

    });

  });

  $perl;
}

=head1 NAME

  Catmandu::Fix::datetime_format - Catmandu Fix for converting between datetime formats

=head1 SYNOPSIS

  datetime_format('timestamp','source_pattern' => '%s','destination_pattern' => '%Y-%m-%d','time_zone' => 'UTC','set_time_zone' => 'Europe/Brussels','delete' => 1)

=head1 AUTHOR

Nicolas Franck, C<< <nicolas.franck at ugent.be> >>

=head1 SEE ALSO

L<Catmandu::Fix>

=cut

1;
