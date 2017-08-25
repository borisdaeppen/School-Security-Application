package Fulla::Werchzueg;

use v5.20;
use strict;
use warnings;

my $database = undef;
my $logger   = undef;

# register a database globally
sub set_database {
    my $class        = shift;
    my $new_database = shift;

    $database = $new_database;
}

# get the registered database instance
sub get_database {
    return $database;
}

# register a login framework globally
sub set_logger {
    my $class      = shift;
    my $new_logger = shift;

    $logger = $new_logger;
}

# get the registered login framework instance
sub get_logger {
    return $logger;
}

1;

# Reminder Singleton:
# http://perltricks.com/article/52/2013/12/11/Implementing-the-singleton-pattern-in-Perl/

__END__

=encoding UTF-8

=head1 NAME

Fulla::Werchzueg - Singleton class to access several tools

This module is part of the C<Fulla> project.

=head1 SYNOPSIS

 Fulla::Werchzueg->get_logger()->debug('hello world');
 Fulla::Werchzueg->get_database()->selectrow_array('select * from table');

=head1 METHODS

=head2 set_logger

Takes a variable of any logging facility as the first argument.
The facility can then be accessed via the C<get> method.

=head2 set_database

Takes a variable of any databse facility as the first argument.
The facility can then be accessed via the C<get> method.

=head2 get_logger

Returns the registered logging facility.
If no facility was registered, C<undef> is returned.

=head2 get_database

Returns the registered database facility.
If no facility was registered, C<undef> is returned.

=head1 AUTHOR

© Boris Däppen, Biel, 2017
