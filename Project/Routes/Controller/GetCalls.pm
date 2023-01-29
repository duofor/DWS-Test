package Routes::Controller::GetCalls;

use Moose;
use Data::Dumper;

use lib qw(.);
use Util::Database;
use Util::JSON;

extends 'Routes::Router';

sub serviceGET {
    my ($self, $params) = @_;

    my $database = Util::Database->new();
    my $response = $database->most_expensive_calls( $params );

    my $jscoder = Util::JSON->new();
    my $json_response = $jscoder->json_coder->encode( $response );
        
    print Dumper $json_response;

    return $json_response;
}

1;