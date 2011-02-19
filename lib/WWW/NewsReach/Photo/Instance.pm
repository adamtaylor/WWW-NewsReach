# ABSTRACT: Models a photo instance in the NewsReach API
package WWW::NewsReach::Photo::Instance;

use Moose;

use URI;

has $_ => (
    is => 'ro',
    isa => 'Int',
) for qw( width height );

has type => (
    is => 'ro',
    isa => 'Str',
);

has url => (
    is => 'ro',
    isa => 'URI',
);

=head1 METHODS

=head2 WWW::NewsReach::Photo::Instance->new_from_xml

Creates a new WWW::NewsReach::Photo::Instance object from the
<instance> ... </instance> XML element returned from a NewsReach API request.

=cut

sub new_from_xml {
    my $class = shift;
    my ( $xml ) = @_;

    my $self = {};

    foreach (qw[ width height ]) {
        $self->{$_} = $xml->findnodes("//$_")->[0]->textContent;
    }

    $self->{type} = $xml->findnodes("//type")->[0]->textContent;

    $self->{url} = URI->new( $xml->findnodes("//url")->[0]->textContent );

    return $class->new( $self );
}

1;
