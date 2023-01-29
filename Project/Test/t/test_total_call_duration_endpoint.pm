package Test::t::test_total_call_duration_endpoint;

use strict;
use warnings;

use Data::Dumper;
use Test::More;
use utf8;

use lib qw(.);
use Test::RestApi;
use Util::JSON;

subtest 'test_total_call_duration', sub {
    my $url = 'http://127.0.0.1:3000/total';
    my $query_args = { 
        start_date => '15/08/2016',
        end_date => '25/08/2016',
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);

    ok( $response_decoded->{total_call_duration} =~ /^\d+$/, "total_call_duration is a number and looks good" );
    ok( $response_decoded->{total_number_of_calls} =~ /^\d+$/, "total_number_of_calls is a number and looks good" );
    ok( !exists $response_decoded->{type}, "type does not exist" );
    is( $status_code, 200, "Status code is 200" );
};

subtest 'test_total_call_duration_with_filtering', sub {
    my $url = 'http://127.0.0.1:3000/total';
    my $query_args = { 
        start_date => '15/08/2016',
        end_date => '25/08/2016',
        type => 1
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);

    ok( $response_decoded->{total_call_duration} =~ /^\d+$/, "total_call_duration is a number and looks good" );
    ok( $response_decoded->{total_number_of_calls} =~ /^\d+$/, "total_number_of_calls is a number and looks good" );
    is( $response_decoded->{type}, 1, "type is 1 and is correct" );
    is( $status_code, 200, "Status code is 200" );
};

subtest 'test_total_call_duration_with_bad_filtering', sub {
    my $url = 'http://127.0.0.1:3000/total';
    my $query_args = { 
        start_date => '15/08/2016',
        end_date => '25/08/2016',
        type => 3
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);

    is( $response_decoded->{total_call_duration}, 0, "total_call_duration is a number and is 0" );
    is( $response_decoded->{total_number_of_calls}, 0, "total_number_of_calls is a number and is 0" );
    is( $response_decoded->{type}, 3, "type is 3 and is correct" );
    is( $status_code, 200, "Status code is 200" );
};

subtest 'test_total_call_duration_with_exceeded_duration', sub {
    my $url = 'http://127.0.0.1:3000/total';
    my $query_args = { 
        start_date => '15/08/2016',
        end_date => '15/09/2016',
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);

    is( $response_decoded->{Message}, "Date duration exceeds 1 month", "Exceed duration error is ok" );
    is( $status_code, 400, "Status code is 400" );
};

subtest 'test_total_call_duration_with_extra_fields', sub {
    my $url = 'http://127.0.0.1:3000/total';
    my $query_args = { 
        start_date => '15/08/2016',
        end_date => '25/08/2016',
        type => 2,
        extra_field => 'error_causer'
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);

    ok( $response_decoded->{total_call_duration} =~ /^\d+$/, "total_call_duration is a number and looks good" );
    ok( $response_decoded->{total_number_of_calls} =~ /^\d+$/, "total_number_of_calls is a number and looks good" );
    is( $response_decoded->{type}, 2, "type is 2 and is correct" );
    ok( !exists $response_decoded->{extra_field}, "Extra field is ignored" );
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