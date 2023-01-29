package Routes::Controller::Query;

use Moose;
use Data::Dumper;

use lib qw(.);
use Util::Database;
use Util::JSON;

extends 'Routes::Router';

sub serviceGET {
    my ($self, $params) = @_;

    my $database = Util::Database->new();
    my $response = $database->exec_select( $params );
    my $status_code = 200;

    return ($response, $status_code);
}

=pod 

=head1 NAME

Routes::Controller::Query

=head1 DESCRIPTION

Extends Routes::Router and implements serviceGET method

=head1 Attributes

=over 4

=head1 Methods

=over 4

=item * serviceGET

Defined route GET request behaviour.
Processes the request and returns the response as perl data structure and the response_code

=back

=cut

1;