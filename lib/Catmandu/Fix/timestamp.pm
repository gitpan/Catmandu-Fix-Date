package Catmandu::Fix::timestamp;
use Catmandu::Sane;
use Time::HiRes;
use Moo;

our $VERSION = "0.0121";

with 'Catmandu::Fix::Base';

has field => (
  is => 'ro' , 
  required => 1
);

around BUILDARGS => sub {
  my($orig,$class,$field) = @_;
  $orig->($class,field => $field);
};

sub emit {
  my($self,$fixer) = @_;

  my $perl = "";  

  my $path = $fixer->split_path($self->field());
  my $key = pop @$path;

  $perl .= $fixer->emit_walk_path($fixer->var,$path,sub{
    my $var = shift;
    $fixer->emit_get_key($var,$key, sub {
      my $var = shift;
      "${var} = Time::HiRes::time;";
    });
  });

  $perl;
}

=head1 NAME

  Catmandu::Fix::timestamp - Catmandu fix that stores the current unix time, in high resolution

=head1 SYNOPSIS

  #set the key 'timestamp' to the current time (unix timestamp)
  timestamp('timestamp')

=head1 AUTHOR

Nicolas Franck, C<< <nicolas.franck at ugent.be> >>

=head1 SEE ALSO

L<Catmandu::Fix>

=cut

1;
