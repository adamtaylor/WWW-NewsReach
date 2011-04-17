# ABSTRACT: LWP::UserAgent wrapper
=head1 NAME

WWW::NewsReach::Client - LWP::UserAgent wrapper for making GET requests

=head1 METHODS

=head2 WWW::NewsReach::Client->new()

=cut

package WWW::NewsReach::Client;

our $VERSION = '0.05';

use Moose;

use LWP::UserAgent;

has ua => (
    is          => 'ro',
    isa         => 'LWP::UserAgent',
    lazy_build  => 1,
);

sub _build_ua {
    my $self = shift;

    return LWP::UserAgent->new;
}

=head2 $client->request( $url )

Make a LWP::UserAgent->get request to the specified URL and return the response

=cut

sub request {
    my $self    = shift;
    my ( $url ) = @_;

    my $res = $self->ua->get( $url );

    if ( $res->is_success ) {
        return $res->content;
    }
}

1;
