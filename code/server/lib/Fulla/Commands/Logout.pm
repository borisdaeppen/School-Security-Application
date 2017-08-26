package Fulla::Commands::Logout;

use v5.22;
use warnings;

sub reply {
    my $class   = shift;
    my $auth    = shift;
    my $session = shift;

    delete $auth->{SESSION}->{$session};

    return 'Ausgeloggt';
}

1;

__END__

=encoding UTF-8

=head1 NAME

C<Fulla::Commands::Logout> - processes the command I<logout>. B<NOTE:> See C<Fulla::Auth> for authentication.

This module is part of the C<Fulla> project.

=head1 SYNOPSIS

Alle implementations in C<Fulla::Commands> must implement a C<reply()> method.
The arguments and return value of C<reply()> depend on the implementation.

 print Fulla::Commands::Login->reply();
 
=head1 METHODS
 
=head2 reply
 
No arguments processed.
Deletes current session.
 
=head1 AUTHOR
 
© Boris Däppen, Biel, 2017
