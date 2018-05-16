package Fulla::Dos;

use v5.22;
use warnings;

# constructor method for object
sub new {
    my $class = shift;
    my $min_pause_in_seconds = shift;

    my $self = { dos_list => {},
                 pause    => $min_pause_in_seconds,
               };

    bless $self, $class;

    return $self;
}

# check a client request for authorisation
sub check {
    my $self = shift;
    my $id   = shift;

    # DOS-Überprüfung im Server-Loop
    my $current_time = time();
    my $last_access  = $self->{dos_list}->{$id};
    
    $self->{dos_list}->{$id} = $current_time;
    
    if ($last_access) {
        my $span = $current_time - $last_access;
        if ($span < $self->{pause}) {
            # DOS
			return 1;
            next;
        }
    }
    # no DOS
	return;
}

1;
