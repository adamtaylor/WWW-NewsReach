=head1 NAME

WWW::NewsReach - Perl wrapper for the NewsReach API

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 WWW::NewsReach->new({ api_key => $api_key })

=cut

package WWW::NewsReach;

use strict;
use warnings;

our $VERSION = '0.01';

use Moose;

use LWP::UserAgent;
use XML::LibXML;
use Data::Dump qw( pp );

use WWW::NewsReach::NewsItem;
use WWW::NewsReach::Client;

my $API_BASE = 'http://api.newsreach.co.uk/';

has api_key => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
);

has ua => (
    is => 'ro',
    isa => 'WWW::NewsReach::Client',
    lazy_build => 1,
);

has api_url => (
    is => 'ro',
    isa => 'Str',
    lazy_build => 1,
);

has news_url => (
    is => 'rw',
    isa => 'Str',
    required => 0,
);

has comments_url => (
    is => 'rw',
    isa => 'Str',
    required => 0,
);

has categories_url => (
    is => 'rw',
    isa => 'Str',
    required => 0,
);

# Construct some of the API URLs based on the root API response
sub BUILD {
    my $self     = shift;
    my ( $args ) = @_;

    my $resp = $self->ua->request( $self->api_url );
    my $xp   = XML::LibXML->new->parse_string( $resp );
    # Use XPATH to find the element attributes from the XML response
    my $news_url       = $xp->findnodes('//news/@href')->[0]->textContent;
    my $comments_url   = $xp->findnodes('//comments/@href')->[0]->textContent;
    my $categories_url = $xp->findnodes(
        '//categoryDefinitions/@href'
    )->[0]->textContent;

    #warn pp $news_url, $comments_url, $categories_url;
    $self->news_url( $news_url );
    $self->comments_url( $comments_url );
    $self->categories_url( $categories_url );

}

sub _build_ua {
    my $self = shift;

    return WWW::NewsReach::Client->new;
}

sub _build_api_url {
    my $self = shift;

    return $API_BASE . $self->api_key;
}


=head2 $nr->get_news();

Get a list of NewsItems from NewsReach.

Returns a list of WWW::NewsReach::NewsItem objects in list context or a referrence
to the list.

=cut

sub get_news {
    my $self = shift;

    my $resp = $self->ua->request( $self->news_url );

    my $news;
    my $xp = XML::LibXML->new->parse_string( $resp );
    foreach ($xp->findnodes('//newsListItem')) {
        #warn pp $_->find('id')->[0]->textContent;
        my $id = $_->find('id')->[0]->textContent;
        my $xml = $self->_get_news_item_xml( $id );
        push @$news, WWW::NewsReach::NewsItem->new_from_xml( $xml );
    }

    return wantarray ? @$news : $news;
}

sub _get_news_item_xml {
    my $self = shift;
    my ( $id ) = @_;

    my $news_item_url = $self->news_url . $id;
    my $resp = $self->ua->request( $news_item_url );
    my $xml = XML::LibXML->new->parse_string( $resp );

    return $xml;
}

1;
