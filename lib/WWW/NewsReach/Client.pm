package WWW::NewsReach::Client;

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

sub request {
    my $self    = shift;
    my ( $url ) = @_;

    my $res = $self->ua->get( $url );

    if ( $res->is_success ) {
        return $res->content;
    }
}

1;
