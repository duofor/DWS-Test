package Routes::Controller::CallerID;

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
    my $response = $database->caller_id( $params );

    my $jscoder = Util::JSON->new();
    my $json_response = $jscoder->json_coder->encode( $response );
        
    print Dumper $json_response;

    return $json_response;
}

1;