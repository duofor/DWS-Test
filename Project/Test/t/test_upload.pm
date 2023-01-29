package Test::t::test_upload;

use strict;
use warnings;

use Data::Dumper;
use Test::More;
use utf8;

use lib qw(.);
use Test::RestApi;
use Util::JSON;

subtest 'test_upload_file', sub {
    my $url = 'http://127.0.0.1:3000/upload';

    my ($response_decoded, $status_code) = send_post_request($url);

    is( $response_decoded->{Message}, "Success", "Upload was successfull" );
    is( $status_code, 200, "Status code is 200" );
};

sub send_post_request {
    my ($url) = @_;

    my $url_obj = URI->new($url);

    my $rest_api = Test::RestApi->new();
    
    my $file_path = 'Data\cdr_upload_test.csv';

    my $response = $rest_api->user_agent()->post( 
        $url_obj, 
        'Content_Type' => 'form-data',
        'Content' => [
            'cdr' => [ $file_path ]   
        ]
    );

    my $status_code = $response->code();

    print Dumper $response->content;

    my $jscoder = Util::JSON->new();
    my $response_decoded = $jscoder->json_coder()->decode( $response->content() ) 
        or die "bad response: cannot decode" . $response->content();

    print Dumper $response_decoded;

    return ( $response_decoded, $status_code );
}

done_testing();