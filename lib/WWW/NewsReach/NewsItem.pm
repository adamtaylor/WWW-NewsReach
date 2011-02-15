=head1 NAME

WWW::News::Reach::NewsItem - Models a NewsItem in the NewsReach API

=cut

package WWW::NewsReach::NewsItem;

use strict;
use warnings;

use Moose;

use XML::LibXML;
use LWP::UserAgent;

use WWW::NewsReach::Photo;

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
    isa => 'ArrayRef[WWW::NewsReach::Photo]',
);

has categories => (
    is => 'ro',
    isa => 'ArrayRef[WWW::NewsReach::Category]',
);

has comments => (
    is => 'ro',
    isa => 'ArrayRef[WWW::NewsReach::Comment]',
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

    my $photo_xml = $class->_get_photo_xml( $xml );
    foreach ( $photo_xml->findnodes('//photo') ) {
        push @{$self->{photos}},
            WWW::NewsReach::Photo->new_from_xml( $_ );
    }

    #$self->{categories} = WWW::NewsReach::NewsItem::Categories->new_from_xml(
        #$xml->findnodes('//categories/@href')->[0]
    #);

    #$self->{comments} = WWW::NewsReach::NewsItem::Comments->new_from_xml(
        #$xml->findnodes('//comments/@href')->[0]
    #);

    return $class->new( $self );
}

sub _get_photo_xml {
    my $class = shift;
    my ( $xml ) = @_;

    my $url = $xml->findnodes('//photos/@href')->[0]->textContent;

    my $resp = $class->_request( $url );
    my $photo_xml = XML::LibXML->new->parse_string( $resp );

    return $photo_xml;
}

sub _request {
    my $self    = shift;
    my ( $url ) = @_;
    
    my $ua = LWP::UserAgent->new;
    my $res = $ua->get( $url );

    if ( $res->is_success ) {
        return $res->content;
    }
}

1;
