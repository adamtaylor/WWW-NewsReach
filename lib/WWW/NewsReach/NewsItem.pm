=head1 NAME

WWW::News::Reach::NewsItem - Models a NewsItem in the NewsReach API

=cut

package WWW::NewsReach::NewsItem;

use strict;
use warnings;

use Moose;

has $_ => (
    is => 'ro',
    isa => 'Str',
) for qw(headline text state extract);

has $_ => (
    is => 'ro',
    isa => 'DateTime',
) for qw(publish_date last_modified_date);

has id => (
    is => 'ro',
    isa => 'Int',
);

has photos => (
    is => 'ro',
    isa => 'WWW::NewsReach::NewsItem::Photo',
);

has categories => (
    is => 'ro',
    isa => 'WWW::NewsReach::NewsItem::Category',
);

has comments => (
    is => 'ro',
    isa => 'WWW::NewsReach::NewsItem::Comment',
);

=head1 METHODS

=head2 WWW::NewsReach::NewsItem->new_from_xml

Creates a new WWW::NewsReach::NewsItem object from an XML::Element object that
has been created from an <newsItem> ... </newsItem> element in the XML returned
from a NewsReach API request.

=cut

sub new_from_xml {
    my $class = shift;
    my ( $xml ) = @_;

    my $self = {};

    foreach (qw[id headline text state extract]) {
        warn $_ . ' = ' . $xml->findnodes("//$_")->[0]->textContent;
        $self->{$_} = $xml->findnodes("//$_")->[0]->textContent;
    }

    $self->{photos} = WWW::NewsReach::NewsItem::Photo->new_from_xml(
        $xml->findnodes("//photo/@href)->[0]
    );

    return $class->new( $self );
}

1;
