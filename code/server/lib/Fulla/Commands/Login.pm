#package Fulla::Commands::Login;

use v5.22;
use warnings;

use Dios;

class Fulla::Commands::Login {

    method reply {

        # authentication happens in Fulla::Auth
        return 'Hallo!';
    }

}

1;

__END__

=encoding UTF-8

=head1 NAME

C<Fulla::Commands::Login> - processes the command I<login>. Provide a hello message. B<NOTE:> No authentication implemented here. See C<Fulla::Auth> for authentication.

This module is part of the C<Fulla> project.

=head1 SYNOPSIS

Alle implementations in C<Fulla::Commands> must implement a C<reply()> method.
The arguments and return value of C<reply()> depend on the implementation.

 print Fulla::Commands::Login->reply();
 
=head1 METHODS
 
=head2 reply
 
No arguments processed.
Returns a hello-message as string.
 
=head1 AUTHOR
 
© Boris Däppen, Biel, 2017
