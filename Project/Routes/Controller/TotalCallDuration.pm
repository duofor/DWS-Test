package Routes::Controller::TotalCallDuration;

use Moose;
use Data::Dumper;

use lib qw(.);
use Util::Database;
use Util::JSON;
use Util::Util;

extends 'Routes::Router';

sub serviceGET {
    my ($self, $params) = @_;
    
    my $response;
    my $status_code;

    if ( Util::Util::is_time_interval_too_large($params->{start_date}, $params->{end_date}) ) {
        $response = {
            Message => "Date duration exceeds 1 month",
            ErrorCode => 400 
        };
        $status_code = 400;

    } else {
        my $database = Util::Database->new();
        my $db_result = $database->total_duration_of_calls_in_period( $params );

        my $number_of_calls = scalar @$db_result;    
        my $total_call_duration = 0;
        foreach my $call_duration ( @$db_result ) {
            $total_call_duration += $call_duration;
        }

        $response = { 
            total_call_duration => $total_call_duration,
            total_number_of_calls => $number_of_calls
        };

        if ( defined $params->{type} ) {
            $response->{type} = $params->{type}
        };

        $status_code = 200;
    }
        
    return ($response, $status_code);
}

1;