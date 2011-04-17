# ABSTRACT: Models a comment in the NewsReach API
package WWW::NewsReach::Comment;

our $VERSION = '0.06';

use Moose;

use DateTime;
use DateTime::Format::ISO8601;

has id => (
    is => 'ro',
    isa => 'Int',
);

has $_ => (
    is => 'ro',
    isa => 'Str',
) for qw( text name location );

has postDate => (
    is => 'ro',
    isa => 'DateTime',
);
=head1 METHODS

=head2 WWW::NewsReach::Comment->new_from_xml

Create a new WWW::NewsReach::Comment object from the
<commentListItem> ... </commentListItem> element in the XML returned from a
NewsReach API request.

=cut

sub new_from_xml {
    my $class = shift;
    my ( $xml ) = @_;

    my $self = {};

    foreach (qw[id text name location]) {
        $self->{$_} = $xml->findnodes("//$_")->[0]->textContent;
    }

    my $dt_str        = $xml->findnodes("//postDate");
    my $dt            = DateTime::Format::ISO8601->new->parse_datetime( $dt_str );
    $self->{postDate} = $dt;

    return $class->new( $self );
}

1;
