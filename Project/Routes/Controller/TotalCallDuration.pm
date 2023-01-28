package Routes::Controller::TotalCallDuration;

use strict;
use warnings;

use Data::Dumper;
use Mojo::Base 'Mojolicious::Controller';

use lib qw(.);
use Util::RestUtil;
use Util::Database;
use Util::JSON;

sub process_request {
	my ($self) = @_;

    my ($json_response, $status_code);

    eval {
        my $params = $self->req->params->to_hash;
        
        my $service_method = 'service' . uc $self->req->method();  
        $json_response = $self->$service_method($params);
        $status_code = 200;
    };
	if ($@) {
		say $@;
		$json_response = Util::RestUtil::_get_server_error_response_json();
        $status_code = 400;
	}

    $self->render( json => $json_response, status => $status_code );
}

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