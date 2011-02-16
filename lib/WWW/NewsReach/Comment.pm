=head1 NAME

=cut

package WWW::NewsReach::Comment;

use strict;
use warnings;

use Moose;

has id => (
    is => 'ro',
    isa => 'Int',
);

has $_ => (
    is => 'ro',
    isa => 'Str',
) for qw( text name location );

has date => (
    is => 'ro',
    isa => 'DateTime',
);
=head1 METHODS

=head2 WWW::NewsReach::Category->new_from_xml

=cut

sub new_from_xml {
    my $class = shift;
    my ( $xml ) = @_;

    my $self = {};

    foreach (qw[id text name location]) {
        warn $_ . ' = ' . $xml->findnodes("//$_")->[0]->textContent;
        $self->{$_} = $xml->findnodes("//$_")->[0]->textContent;
    }

    ## TODO findnodes("postDate");
    return $class->new( $self );
}

1;
