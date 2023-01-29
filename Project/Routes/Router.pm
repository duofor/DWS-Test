package Routes::Router;

use strict;
use warnings;

use Data::Dumper;
use Mojo::Base 'Mojolicious::Controller';

use lib qw(.);
use feature 'say';
use Util::RestUtil;

sub process_request {
	my ($self) = @_;

    my ($json_response, $status_code) = ( '', 404 );
    
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

    die "No implementation of method serviceGET was found in " . ref $self;
}

1;