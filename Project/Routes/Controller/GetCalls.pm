package Routes::Controller::GetCalls;

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

    if ( !exists $params->{caller_id} ) {
        $response = {
            Message => "caller_id is missing",
            ErrorCode => 400 
        };
        $status_code = 400;

        return ($response, $status_code);
    }

    if ( !exists $params->{number_of_calls} ) {
        $response = {
            Message => "number_of_calls is missing",
            ErrorCode => 400 
        };
        $status_code = 400;

        return ($response, $status_code);
    }

    if ( Util::Util::is_time_interval_too_large($params->{start_date}, $params->{end_date}) ) {
        $response = {
            Message => "Date duration exceeds 1 month",
            ErrorCode => 400 
        };
        $status_code = 400;

    } else {
        my $database = Util::Database->new();
        $response = $database->most_expensive_calls( $params );
        $status_code = 200;
    }
        
    return ($response, $status_code);
}

1;