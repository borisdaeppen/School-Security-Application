package Fulla::CommandDispatcher;

use v5.22;
use warnings;
no warnings 'experimental'; # disable warnings from given/when

use DBI; # with DBD::mysql

use Fulla::Auth;
use Fulla::Dos;
use Fulla::Commands::Login;
use Fulla::Commands::Logout;
use Fulla::Commands::Register;
use Fulla::Commands::Ping;
use Fulla::Commands::List;
use Fulla::Commands::Artikel;
use Fulla::Commands::ArtikelNeu;
use Fulla::Commands::ArtikelLoeschen;
use Fulla::Commands::HTTP::Artikel;

# constructor method for object
sub new {
    my $class = shift;

    my $log   = Fulla::Werchzueg->get_logger();
    my $dbh   = Fulla::Werchzueg->get_database();
    my $auth  = Fulla::Auth->new();
    my $dos   = Fulla::Dos->new(2);

    my $self = { log  => $log,
                 dbh  => $dbh,
                 auth => $auth,
                 dos  => $dos,
               };
    bless $self, $class;

    return $self;
}

# take a request
# check authentication
# dispatch to module, according to command
sub do {
    my $self    = shift;
    my $command = shift;

    my $answer  = '';

    $self->{log}->debug( "command: $command");

    # anything which looks like HTTP is directly forwarded
    # this bypasses the Auth/Login machanism, so only read-services of
    # unproblematic data should be implemented
    if ($command =~ /^\d+\sHTTP$/i or $command =~ /^(GET|PUT).*\sHTTP\//i) {
        return Fulla::Commands::HTTP::Artikel->reply();
    }

    # check if request is authenticated
    my ($session, $auth_msg) = $self->{auth}->check($command);

    $self->{log}->debug( "session after auth: $session");

    if ( $session eq '00000000000000000000' ) {
        $self->{log}->info("auth problem: $auth_msg");
        $answer = "00000000000000000000 $auth_msg";
        # EXIT
        return $answer;
    }

    #######################################################
    # From here on only authorised messages are processed #
    #######################################################

    if ($self->{dos}->check($session)) {
        $answer = "00000000000000000000 too many requests";
        # EXIT
        return $answer;
    }

    $self->{log}->debug( "command before parse: $command");

    # does the request look like a valid command?
    if ($command =~ /^\d+\s(.*)/) {

        # extract the command (delete session-id from string)
        $command = $1;

        $self->{log}->debug( "command in parse: $command" );

        # choose a module, if the command is known
        # directly process the command ans store result in $answer
        given ($command) {

            # LOGIN
            when (/^login/) {
                $answer = Fulla::Commands::Login->reply();
            }

            # REGISTER
            when (/^register\s+(\S+)\s+(\S+)/) {
                my $user = $1;
                my $pass = $2;
                $answer = Fulla::Commands::Register->reply($user, $pass);
            }

            # LOGOUT
            when (/^logout/) {
                $answer = Fulla::Commands::Logout->reply($self->{auth}, $session);
                $session = '00000000000000000000';
            }

            # PING
            when (/^ping/)  {
                $answer = Fulla::Commands::Ping->reply();
            }
    
            # ARTIKEL
            when (/^artikel\s?(.*)/) { 
                my $artikel = '';
                $artikel = $1 if $1;
                $answer = Fulla::Commands::Artikel
                            ->reply( $artikel );
            }

            # ARTIKEL NEU
            when (/^neuerartikel\s(.*)\s(\S*)\s(\S*)/) { 
                my $artikel = $1;
                my $bestand = $2;
                my $preis   = $3;
                $answer = Fulla::Commands::ArtikelNeu
                            ->reply( $artikel, $bestand, $preis );
            }

            # ARTIKEL LÖSCHEN
            when (/^loescheartikel\s(\d+)/) { 
                my $id = $1;
                $answer = Fulla::Commands::ArtikelLoeschen->reply($id);
            }

            # LIST
            when (/^list\s?(.*)/)  {
                my $option = $1;
                $answer = Fulla::Commands::List->reply($option);
            }
    
            # DEFAULT: command has no implementation
            default {
                $answer = "command not supported: $command"
            }
        }
    }
    # request syntax invalid
    else {
        $answer = "command syntax invalid: $command";
    }

    # return processed result with session-id attached
    return "$session $answer";
}

1;

__END__

=encoding UTF-8

=head1 NAME

Fulla::CommandDispatcher - delegate incoming commands to responsible modules

This module is part of the C<Fulla> project.

=head1 SYNOPSIS

 my $client_data = '1234567890 ping';

 my $cd = Fulla::CommandDispatcher->new();

 my $answer = $cd->do($client_data);

 print $answer;


=head1 METHODS

=head2 new

Create an object instance.

 my $cd  = Fulla::CommandDispatcher->new();

=head2 do

Takes a complete C<Fulla> request as the first argument.

 print $cd->do('1234567890 ping');

The autorisation of the request is first checked via C<Fulla::Auth>.
Then the request is sent to a responsible module for processing.

The returned value is a valid C<Fulla> answer string, containing a session-id and the requested data.

=head1 AUTHOR

© Boris Däppen, Biel, 2017
