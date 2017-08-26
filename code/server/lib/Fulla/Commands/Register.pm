package Fulla::Commands::Register;

use v5.22;
use warnings;

use DBI;
use Digest;
use Digest::MD5;

sub reply {
    my $class = shift;
    my $user  = shift;
    my $pass  = shift;

    my $log   = Fulla::Werchzueg->get_logger();
    my $dbh   = Fulla::Werchzueg->get_database();

    my $pw_hash= Digest->new('MD5')->add($pass)->hexdigest;
    my $sql = "INSERT INTO user (name, pw_algo, pw_hash, berechtigung, algo_param, pw_salt) VALUES ( '$user', 'md5', '$pw_hash', 0, 0, '' );";
    $log->debug("QUERY: $sql");

    my $sth = $dbh->prepare($sql);
    $sth->execute();

    return "Benutzer '$user' wurde registriert.";
}

1;

__END__

=encoding UTF-8

=head1 NAME

C<Fulla::Commands::Register> - processes the command I<register>. Stores a new user and password in the database.

This module is part of the C<Fulla> project.

=head1 SYNOPSIS

Alle implementations in C<Fulla::Commands> must implement a C<reply()> method.
The arguments and return value of C<reply()> depend on the implementation.

 print Fulla::Commands::Register->reply($user, $pw);
 
=head1 METHODS
 
=head2 reply
 
Takes two arguments:
username and password.
Stores user and hashed password in the database.
 
=head1 AUTHOR
 
© Boris Däppen, Biel, 2017
