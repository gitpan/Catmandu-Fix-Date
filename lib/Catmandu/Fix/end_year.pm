package Catmandu::Fix::end_year;
use Catmandu::Sane;
use Moo;
use Catmandu::Util qw(:is :check :array);
use DateTime::Format::Strptime;
use DateTime::TimeZone;
use DateTime;

our $VERSION = "0.0122";

with 'Catmandu::Fix::Base';

has path => (
    is => 'ro' ,
    required => 1
);
has add => (
    is => 'ro',
    isa => sub { check_integer($_[0]); },
    required => 0,
    lazy => 1,
    default => sub { 0; }
);
has time_zone => (
    is => 'ro',
    required => 1,
    isa => sub {
        check_string($_[0]);
    },
    default => sub {
        "UTC"
    }
);
has pattern => (
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
    my($orig,$class,$path,%args) = @_;
    $orig->($class,
        path => $path,
        %args
    );
};

sub emit {
    my($self,$fixer) = @_;

    my $path = $fixer->split_path($self->path());
    my $end_year = $fixer->capture(sub{
        my $skip = shift;
        #we need to set the time zone first before doing any math!
        my $d = DateTime->now->set_time_zone($self->time_zone)->truncate(to => "day");

        $d->set_month(1);
        $d->set_day(1);

        $d->add(seconds => -1,years => 1);

        if(is_integer($skip)){
            $d->add(years => $skip);
        }

        $d;

    });

    $fixer->emit_create_path($fixer->var,$path,sub{

        my $var = shift;

        my $d = $fixer->generate_var();
        my $p  = $fixer->emit_declare_vars($d);
        $p .= " $d = ${end_year}->(".$self->add().");";
        $p .= " ${var} = DateTime::Format::Strptime::strftime('".$self->pattern()."',$d);";

        $p;

    });

}

=head1 NAME

  Catmandu::Fix::end_year - Catmandu Fix for retrieving date string for end of the year

=head1 SYNOPSIS

  #get end of the year in time zone Europe/Brussels
  end_year('end_year','pattern' => '%Y-%m-%dT%H:%M:SZ','time_zone' => 'Europe/Brussels')

  #get end of next year in time zone Europe/Brussels
  end_year('end_year','pattern' => '%Y-%m-%dT%H:%M:SZ','time_zone' => 'Europe/Brussels', 'add' => 1)

=head1 AUTHOR

Nicolas Franck, C<< <nicolas.franck at ugent.be> >>

=head1 SEE ALSO

L<Catmandu::Fix>

=cut

1;
