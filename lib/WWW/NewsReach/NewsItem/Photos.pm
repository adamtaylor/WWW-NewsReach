=head1 NAME

=cut

package WWW::NewsReach::NewsItem::Photos;

use strict;
use warnings;

use Moose;
use LWP::UserAgent;

use WWW::NewsReach::Photo;

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
    isa => 'ArrayRef[WWW::NewsReach::Photo]',
);

=head1 METHODS

=head2 WWW::NewsReach::NewsItem::Photos->new_from_href

=cut

sub new_from_href {
    my $class = shift;
    my ( $href ) = @_;

    my $self = {};

    my $xml = $class->_get_xml( $href );

    foreach (qw[id caption htmlAlt orientation]) {
        warn $_ . ' = ' . $xml->findnodes("//$_")->[0]->textContent;
        $self->{$_} = $xml->findnodes("//$_")->[0]->textContent;
    }

    foreach ( $xml->findnodes("//instance") ) {
        push @{$self->{instances}},
            WWW::NewsReach::Photo->new_from_xml( $_ );
    }

    return $class->new( $self );
}

sub _get_xml {
    my $class = shift;
    my ( $href ) = @_;
warn $href->textContent;
    my $resp = $class->_request( $href->textContent );
    my $xml = XML::LibXML->new->parse_string( $resp );

    return $xml;
    
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
