=head1 NAME

WWW::NewsReach::Photo - Models a photo in the NewsReach API.

=cut

package WWW::NewsReach::Photo;

use Moose;

use WWW::NewsReach::Photo::Instance;

has $_ => (
    is => 'ro',
    isa => 'Str',
) for qw( caption alt orientation );

has id => (
    is => 'ro',
    isa => 'Int',
);

has instances => (
    is => 'ro',
    isa => 'ArrayRef[WWW::NewsReach::Photo::Instance]',
);

=head1 METHODS

=head2 WWW::NewsReach::Photo->new_from_xml

Creates a new WWW::NewsReach::Photo object from the <photo> ... </photo> element
returned in the XML from a NewsReach API request.

=cut

sub new_from_xml {
    my $class = shift;
    my ( $xml ) = @_;

    my $self = {};

    foreach (qw[id caption orientation]) {
        $self->{$_} = $xml->findnodes("//$_")->[0]->textContent;
    }

    $self->{alt} = $xml->findnodes('//htmlAlt')->[0]->textContent;

    foreach ( $xml->findnodes("//instance") ) {
        push @{$self->{instances}},
            WWW::NewsReach::Photo::Instance->new_from_xml( $_ );
    }

    return $class->new( $self );
}

1;
