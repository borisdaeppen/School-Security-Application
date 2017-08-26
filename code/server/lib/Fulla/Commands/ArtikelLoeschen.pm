package Fulla::Commands::ArtikelLoeschen;

use v5.22;
use warnings;

use Fulla::Werchzueg;

sub reply {
    my $class  = shift;
    my $art_id = shift;
    my $log    = Fulla::Werchzueg->get_logger();
    my $dbh    = Fulla::Werchzueg->get_database();

    my $answer = '';

    my $sql = "DELETE FROM artikel WHERE id = ?;";
    $log->debug("QUERY: $sql PARAM: $art_id");

    my $sth = $dbh->prepare($sql);
    $sth->bind_param(1, $art_id, $dbh::SQL_INTEGER);

    if ($sth->execute()) {
        return "deleted id $art_id from stock";
    }
    else {
        return "something went wrong: couldn't delete id $art_id. " . $DBI::errstr;
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
