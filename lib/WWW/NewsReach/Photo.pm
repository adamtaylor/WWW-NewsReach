=head1 NAME

=cut

package WWW::NewsReach::Photo;

use strict;
use warnings;

use Moose;
use LWP::UserAgent;

use WWW::NewsReach::Photo::Instance;

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
    isa => 'ArrayRef[WWW::NewsReach::Photo::Instance]',
);

=head1 METHODS

=head2 WWW::NewsReach::NewsItem::Photos->new_from_xml

=cut

sub new_from_xml {
    my $class = shift;
    my ( $xml ) = @_;

    my $self = {};

    foreach (qw[id caption htmlAlt orientation]) {
        warn $_ . ' = ' . $xml->findnodes("//$_")->[0]->textContent;
        $self->{$_} = $xml->findnodes("//$_")->[0]->textContent;
    }

    foreach ( $xml->findnodes("//instance") ) {
        push @{$self->{instances}},
            WWW::NewsReach::Photo::Instance->new_from_xml( $_ );
    }

    return $class->new( $self );
}

1;
