package Fulla::Commands::Artikel;

use v5.22;
use warnings;

use Fulla::Werchzueg;

sub reply {
    my $class   = shift;
    my $artikel = shift;
    my $log     = Fulla::Werchzueg->get_logger();
    my $dbh     = Fulla::Werchzueg->get_database();

    my $answer = '';

    my $sql = "SELECT * FROM artikel WHERE bezeichnung LIKE '%$artikel%'";

    $log->debug("QUERY: $sql");

    my $rows = $dbh->selectall_arrayref($sql);

    foreach my $row (@{$rows}) {
        $answer .= join("\t", @{$row});
        $answer .= "\n";
    }

    sleep 1; # simulate some heavy work :-)

    return $answer;

}

1;

__END__

=encoding UTF-8

=head1 NAME

C<Fulla::Commands::Artikel> - processes the command I<artikel>. Search articles in the database.

This module is part of the C<Fulla> project.

=head1 SYNOPSIS

Alle implementations in C<Fulla::Commands> must implement a C<reply()> method.
The arguments and return value of C<reply()> depend on the implementation.

 print Fulla::Commands::Artikel->reply('car');

=head1 METHODS

=head2 reply

Take a pattern (string) as an argument.
The pattern is searched in the database and the result returned as string.

=head1 AUTHOR

© Boris Däppen, Biel, 2017    
