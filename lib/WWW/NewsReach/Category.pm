=head1 NAME

=cut

package WWW::NewsReach::Category;

use strict;
use warnings;

use Moose;

has id => (
    is => 'ro',
    isa => 'Int',
);

has name => (
    is => 'ro',
    isa => 'Str',
);
=head1 METHODS

=head2 WWW::NewsReach::Category->new_from_xml

=cut

sub new_from_xml {
    my $class = shift;
    my ( $xml ) = @_;

    my $self = {};

    foreach (qw[id name]) {
        warn $_ . ' = ' . $xml->findnodes("//$_")->[0]->textContent;
        $self->{$_} = $xml->findnodes("//$_")->[0]->textContent;
    }

    return $class->new( $self );
}

1;
