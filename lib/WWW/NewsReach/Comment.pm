=head1 NAME

=cut

package WWW::NewsReach::Comment;

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
        $self->{$_} = $xml->findnodes("//$_")->[0]->textContent;
    }

    my $dt_str    = $xml->findnodes("//postDate");
    my $dt        = DateTime::Format::ISO8601->new->parse_datetime( $dt_str );
    $self->{date} = $dt;

    return $class->new( $self );
}

1;
