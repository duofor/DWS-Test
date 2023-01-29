package Test::t::test_calls;

use strict;
use warnings;

use Data::Dumper;
use Test::More;
use utf8;

use lib qw(.);
use Test::RestApi;
use Util::JSON;

subtest 'test_most_expensive_calls', sub {
    my $url = 'http://127.0.0.1:3000/calls';

    my $query_args = { 
        caller_id => 441207000000,
        start_date => '15/08/2016',
        end_date => '25/08/2016',
        number_of_calls => 3
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);
    
    foreach my $call_record ( @$response_decoded ) {
        is( $call_record->{caller_id}, $query_args->{caller_id}, "caller_id is ok" );
    }

    is ( scalar @$response_decoded, $query_args->{number_of_calls}, "retrieved exactly $query_args->{number_of_calls} entries");
    is( $status_code, 200, "Status code is 200" );
};

subtest 'test_most_expensive_calls_by_type', sub {
    my $url = 'http://127.0.0.1:3000/calls';

    my $query_args = { 
        caller_id => 441207000000,
        start_date => '15/08/2016',
        end_date => '25/08/2016',
        number_of_calls => 3,
        type => 1
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);

    foreach my $call_record ( @$response_decoded ) {
        is( $call_record->{caller_id}, $query_args->{caller_id}, "caller_id is ok" );
        is( $call_record->{type}, $query_args->{type}, "caller_id is ok" );
    }

    is ( scalar @$response_decoded, $query_args->{number_of_calls}, "retrieved exactly $query_args->{number_of_calls} entries");
    is( $status_code, 200, "Status code is 200" );
};

subtest 'test_most_expensive_calls_invalid_type', sub {
    my $url = 'http://127.0.0.1:3000/calls';

    my $query_args = { 
        caller_id => 441207000000,
        start_date => '15/08/2016',
        end_date => '25/08/2016',
        number_of_calls => 3,
        type => 3
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);

    is ( scalar @$response_decoded, 0, "no calls retrieved due to invalid type");
    is( $status_code, 200, "Status code is 200" );
};

subtest 'test_most_expensive_calls_missing_caller_id', sub {
    my $url = 'http://127.0.0.1:3000/calls';

    my $query_args = { 
        start_date => '15/08/2016',
        end_date => '25/08/2016',
        number_of_calls => 3
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);
    
    is( $response_decoded->{Message}, "caller_id is missing", "missing caller_id error is ok" );
    is( $status_code, 400, "Status code is 400" );
};

subtest 'test_most_expensive_calls_missing_caller_id', sub {
    my $url = 'http://127.0.0.1:3000/calls';

    my $query_args = { 
        caller_id => 441207000000,
        start_date => '15/08/2016',
        end_date => '25/08/2016',
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);
    
    is( $response_decoded->{Message}, "number_of_calls is missing", "missing caller_id error is ok" );
    is( $status_code, 400, "Status code is 400" );
};

subtest 'test_most_expensive_calls_extra_fields', sub {
    my $url = 'http://127.0.0.1:3000/calls';

    my $query_args = { 
        caller_id => 441207000000,
        start_date => '15/08/2016',
        end_date => '25/08/2016',
        number_of_calls => 3,
        extra_field => "error_Causer"
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);
    
    foreach my $call_record ( @$response_decoded ) {
        is( $call_record->{caller_id}, $query_args->{caller_id}, "caller_id is ok" );
        ok( !exists $call_record->{extra_field}, "extra field does not exist" );
    }

    is ( scalar @$response_decoded, $query_args->{number_of_calls}, "retrieved exactly $query_args->{number_of_calls} entries");
    is( $status_code, 200, "Status code is 200" );
};

sub send_get_request {
    my ($url, $query_args) = @_;

    my $url_obj = URI->new($url);
    $url_obj->query_form( $query_args );

    my $rest_api = Test::RestApi->new();
    my $response = $rest_api->user_agent()->get($url_obj);
    my $status_code = $response->code();

    my $jscoder = Util::JSON->new();
    my $response_decoded = $jscoder->json_coder()->decode( $response->content ) 
        or die "bad response: cannot decode" . $response->decoded_content;

    return ( $response_decoded, $status_code );
}

done_testing();