package Fulla::Commands::Ping;

use v5.22;
use warnings;

sub reply {
    my $class = shift;

    return 'pong';
}

1;

__END__

=encoding UTF-8

=head1 NAME

C<Fulla::Commands::Ping> - processes the command I<ping>. Provide test functionality.

This module is part of the C<Fulla> project.

=head1 SYNOPSIS

Alle implementations in C<Fulla::Commands> must implement a C<reply()> method.
The arguments and return value of C<reply()> depend on the implementation.

 print Fulla::Commands::Ping->reply();
 
=head1 METHODS
 
=head2 reply
 
No arguments processed.
Returns  I<pong> as string.
 
=head1 AUTHOR
 
© Boris Däppen, Biel, 2017
