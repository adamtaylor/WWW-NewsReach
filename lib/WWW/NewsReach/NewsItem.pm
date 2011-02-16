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
use WWW::NewsReach::Category;
use WWW::NewsReach::Comment;

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
        $self->{$_} = $xml->findnodes("//$_")->[0]->textContent;
    }

    my $photo_xml = $class->_get_related_xml( $xml, 'photos' );
    foreach ( $photo_xml->findnodes('//photo') ) {
        push @{$self->{photos}},
            WWW::NewsReach::Photo->new_from_xml( $_ );
    }

    my $comment_xml = $class->_get_related_xml( $xml, 'comments' );
    foreach ( $photo_xml->findnodes('//commentListItem') ) {
        push @{$self->{Comment}},
            WWW::NewsReach::Comment->new_from_xml( $_ );
    }

    my $category_xml = $class->_get_related_xml( $xml, 'categories' );
    foreach ( $photo_xml->findnodes('//category') ) {
        push @{$self->{categories}},
            WWW::NewsReach::Category->new_from_xml( $_ );
    }
    #$self->{categories} = WWW::NewsReach::NewsItem::Categories->new_from_xml(
        #$xml->findnodes('//categories/@href')->[0]
    #);

    #$self->{comments} = WWW::NewsReach::NewsItem::Comments->new_from_xml(
        #$xml->findnodes('//comments/@href')->[0]
    #);

    return $class->new( $self );
}

sub _get_related_xml {
    my $class = shift;
    my ( $xml, $type ) = @_;

    my $url = $xml->findnodes("//$type/".'@href')->[0]->textContent;

    my $resp = $class->_request( $url );
    my $related_xml = XML::LibXML->new->parse_string( $resp );

    return $related_xml;
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
