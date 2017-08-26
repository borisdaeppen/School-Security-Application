package Fulla::Commands::ArtikelNeu;

use v5.22;
use warnings;

use Fulla::Werchzueg;

sub reply {
    my $class   = shift;
    my $artikel = shift;
    my $bestand = shift;
    my $preis   = shift;
    my $log     = Fulla::Werchzueg->get_logger();
    my $dbh     = Fulla::Werchzueg->get_database();

    my $answer = '';

    my $sql = "INSERT INTO artikel (bezeichnung, bestand, preis) VALUES (?, ?, ?)";
    $log->debug("QUERY: $sql");

    my $sth = $dbh->prepare($sql);
    $sth->bind_param(1, $artikel, $dbh::SQL_VARCHAR);
    $sth->bind_param(2, $bestand, $dbh::SQL_INTEGER);
    $sth->bind_param(3, $preis,   $dbh::SQL_INTEGER);

    if ($sth->execute()) {
        return "added $artikel in stock";
    }
    else {
        return "something went wrong: couldn't add $artikel to stock";
    }

}

1;

__END__

=encoding UTF-8

=head1 NAME

C<Fulla::Commands::ArtikelNeu> - processes the command I<neuerartikel>. Add new articles to the database.

This module is part of the C<Fulla> project.

=head1 SYNOPSIS

All implementations in C<Fulla::Commands> must implement a C<reply()> method.
The arguments and return value of C<reply()> depend on the implementation.

 print Fulla::Commands::ArtikelNeu->reply('car', 10, 10000);

=head1 METHODS

=head2 reply

Takes 3 arguments: name of article, stock amount, price.
Inserts the article into the database.

=head1 AUTHOR

© Boris Däppen, Biel, 2017    
