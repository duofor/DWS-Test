package Test::t::test_query_endpoint;

use strict;
use warnings;

use Data::Dumper;
use Test::More;
use utf8;

use lib qw(.);
use Test::RestApi;
use Util::JSON;

subtest 'test_reference_retrieval', sub {
    my $url = 'http://127.0.0.1:3000/query';
    my $query_args = { 
        'reference' => 'C5DA9724701EEBBA95CA2CC5617BA93E4'
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);

    is( $response_decoded->[0]->{reference}, $query_args->{reference}, "reference retrieval is ok" );
    is( $status_code, 200, "Status code is 200" );
};

subtest 'test_reference_retrieval_bad_key', sub {
    my $url = 'http://127.0.0.1:3000/query';
    my $query_args = { 
        'reference1' => 'asdb'
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);

    is( $response_decoded->{Message}, "Server error", "bad reference retrieval is ok" );
    is( $status_code, 400, "Status code is 400" );
};

subtest 'test_reference_retrieval_non_existant', sub {
    my $url = 'http://127.0.0.1:3000/query';
    my $query_args = { 
        'reference' => 'asdb'
    };

    my ($response_decoded, $status_code) = send_get_request($url, $query_args);

    is( scalar @$response_decoded, 0, "no reference retrieved" );
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