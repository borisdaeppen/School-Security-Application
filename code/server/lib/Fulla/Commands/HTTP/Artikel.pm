package Fulla::Commands::HTTP::Artikel;

use v5.22;
use warnings;

use Fulla::Werchzueg;
use HTML::Table::FromDatabase;

sub reply {
    my $class   = shift;
    my $log     = Fulla::Werchzueg->get_logger();
    my $dbh     = Fulla::Werchzueg->get_database();

    my $sql = "SELECT artikel.id, artikel.bezeichnung, artikel.bestand AS lagerbestand, kauf.menge AS verkauft FROM artikel LEFT JOIN kauf ON artikel.id = kauf.id_artikel";
    $log->debug("QUERY: $sql");

    my $sth = $dbh->prepare($sql);
    $sth->execute();

    # create a HTML-Table directly from database query result
    my $table = HTML::Table::FromDatabase->new( -sth => $sth );

    my $answer = "<!DOCTYPE html><html lang='de'><head><meta charset='utf-8'><title>Artikel</title></head><body><h1>&Uuml;bersicht Artikel</h1>$table</body></html>";

    my $http_response ="HTTP/1.1 200 OK\nContent-type: text/html\nContent-length: " . length($answer) . "\n\n" . $answer;

    return $http_response;

}

1;

__END__

=encoding UTF-8

=head1 NAME

C<Fulla::Commands::HTTP::Artikel> - List articles as HTML and return it as HTTP.

This module is part of the C<Fulla> project.

=head1 SYNOPSIS

Alle implementations in C<Fulla::Commands> must implement a C<reply()> method.
The arguments and return value of C<reply()> depend on the implementation.

 print Fulla::Commands::HTTP::Artikel->reply();

=head1 METHODS

=head2 reply

No arguments supported.
Returns an HTTP-String with HTML content.
Lists all articles with current stock.

=head1 AUTHOR

© Boris Däppen, Biel, 2017    
