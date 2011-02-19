=head1 NAME

WWW::NewsReach::Category - Models a category in the NewsReach API.

=cut

package WWW::NewsReach::Category;

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

Creates a new WWW::NewsReach::Category object from the <category> ... </category>
XML element returned from a NewsReach API request.

=cut

sub new_from_xml {
    my $class = shift;
    my ( $xml ) = @_;

    my $self = {};

    foreach (qw[id name]) {
        $self->{$_} = $xml->findnodes("//$_")->[0]->textContent;
    }

    return $class->new( $self );
}

1;
