package Fulla::Commands::List;

use v5.20;
use strict;
use warnings;

sub reply {
    my $class  = shift;
    my $option = shift;

    return `ls $option`;

}

1;

__END__

=encoding UTF-8

=head1 NAME

C<Fulla::Commands::List> - processes the command I<list>. List application directory.

This module is part of the C<Fulla> project.

=head1 SYNOPSIS

Alle implementations in C<Fulla::Commands> must implement a C<reply()> method.
The arguments and return value of C<reply()> depend on the implementation.

 print Fulla::Commands::Login->reply();
 
=head1 METHODS
 
=head2 reply
 
First argument can be a string, containing any options supported by the C<ls> command on the server system.
Returns the C<stdout> from C<ls> on the system.

 print Fulla::Commands::List->reply('-l');
 
=head1 AUTHOR
 
© Boris Däppen, Biel, 2017
