package Routes::Router;

use strict;
use warnings;

use Data::Dumper;
use Mojo::Base 'Mojolicious::Controller';

use lib qw(.);
use feature 'say';

sub process_request {
	my ($self) = @_;

    my $json_response = '';
    my $status_code = 200;
    
    eval {
        my $params = $self->req->params->to_hash;
        my $service_method = 'service' . uc $self->req->method();  

        my ($response, $code) = $self->$service_method($params);
        $json_response = $response;
        $status_code = $code;
    };
	if ($@) {
		say $@;
		$json_response = { "Message" => "Server error", "ErrorCode" => 400 };
        $status_code = 400;
	}

    $self->render( json => $json_response, status => $status_code );

    print Dumper $json_response;
    print "status: $status_code\n";
}

sub serviceGET {
    my ($self, $params) = @_;

    die "No implementation of method serviceGET was found in " . ref $self;
}

1;