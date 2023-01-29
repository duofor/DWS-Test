package Routes::Controller::TotalCallDuration;

use Moose;
use Data::Dumper;

use lib qw(.);
use Util::Database;
use Util::JSON;

sub serviceGET {
    my ($self, $params) = @_;

    my $database = Util::Database->new();
    my $response = $database->total_duration_of_calls_in_period( $params );

    my $number_of_calls = scalar @$response;    
    my $total_call_duration = 0;
    foreach my $call_duration ( @$response ) {
        $total_call_duration += $call_duration;
    }

    my $jscoder = Util::JSON->new();
    my $json_response = $jscoder->json_coder->encode({ # TODO: Move to json file
        total_call_duration => $total_call_duration,
        total_number_of_calls => $number_of_calls
    });
        
    print Dumper $json_response;

    return $json_response;
}

1;