package Fulla::Auth;

use v5.22;
use warnings;

use DBI; # with DBD::mysql
use Digest;
use Digest::MD5;
use String::Random;

# constructor method for object
sub new {
    my $class = shift;

    my $log   = Fulla::Werchzueg->get_logger();
    my $dbh   = Fulla::Werchzueg->get_database();

    my $self = { log        => $log,
                 dbh        => $dbh,
                 SESSION    => {},
                 AUTH_MSG   => '',
               };
    bless $self, $class;

    return $self;
}

# check a client request for authorisation
sub check {
    my $self    = shift;
    my $command = shift;

    # enter here if user demands a new login
    if ( $command =~ /^\d*\slogin\s(.+)\s(\S+)$/) { 

        # extract user and password from the login request
        my $user = $1;
        my $pass = $2;

        # calculate the password hash for the password sent by the client
        my $hash_client = Digest->new('MD5')->add($pass)->hexdigest;

        # https://www.w3schools.com/sql/sql_injection.asp
        my $sql = "SELECT id FROM user WHERE name = '$user' and pw_hash = '$hash_client'";
        $self->{log}->debug("QUERY: $sql");

        my $sth = $self->{dbh}->prepare($sql);
        $sth->execute();
        my ($user_id) = $sth->fetchrow_array();

        # hash provided by client must be equal to hash in database
        if ($user_id) {

            # SUCCESSFULL LOGIN
            # generate and store a session-id and return it to caller
            my $session_id = String::Random->new->randregex('\d{20}');
            $self->{SESSION}->{$session_id} = 1;

            return ( $session_id, 'login ok' );;
        }   
        else {

            # FAILED LOGIN
            # return zero to caller
            return ( '00000000000000000000', 'login failed' );;
        }   
    }
    # user does not login...
    elsif ( $command =~ /^(\d{20})\s.*$/ ) {

        # extract the session-id from the request
        my $session_id = $1;

        # see if the session-id is registered already
        # if yes, this means, a successfull login has happened before
        if ( exists $self->{SESSION}->{$session_id} ) {

            # AUTHORISATION OK
            # return session-id to caller
            return ( $session_id, 'session valid' );
        }
        else {

            # AUTHORISATION FAILED
            # return zero to caller
            $self->{log}->info("session not valid: $session_id");
            return ( '00000000000000000000', 'session not valid' );
        }
    }
    # user did not send any session-id
    else {

        # AUTHORISATION FAILED
        # return zero to caller
        return ( '00000000000000000000', 'no session found' );
    }
}

1;

__END__

=encoding UTF-8

=head1 NAME

Fulla::Auth - check and provide session-id's

This module is part of the C<Fulla> project.

=head1 SYNOPSIS

 my $auth  = Fulla::Auth->new();

 my ($session, $auth_msg) = $auth->check('1234567890 ping');

 if ($session) {
     print "session ok, reason: $auth_msg";
 }
 else {
     print "session invalid, reason: $auth_msg";
 }

=head1 METHODS

=head2 new

Create an object instance.

 my $auth  = Fulla::Auth->new();

=head2 check

Check a string for authentication in the C<Fulla> server.
This method may do calls to the database!

 my ($session, $auth_msg) = $auth->check('1234567890 ping');

 my ($session, $auth_msg) = $auth->check('0 login user pw');

The string to check must be a valid request to the C<Fulla> server.
It looks if the string contains a leading number, 20 digits long.
This is interpreted as a session-id.
The session-id is validated via database or internal object state.

If a login request is sent, the password is validated.
If the password is valid, a session-id is created.

The return values are always a session-id and a message.
If the session-id is zero, something went wrong.

=head1 AUTHOR

© Boris Däppen, Biel, 2017 
