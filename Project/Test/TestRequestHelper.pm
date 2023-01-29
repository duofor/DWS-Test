package Test::RequestSender;

use Readonly;
use Data::Dumper;
use feature 'say';

use lib qw(.);
use Test::RestApi;
use Util::JSON;

# my Readonly $url = 'http://127.0.0.1:3000/query';
# my Readonly $url = 'http://127.0.0.1:3000/total';
# my Readonly $url = 'http://127.0.0.1:3000/caller_id';
# my Readonly $url = 'http://127.0.0.1:3000/calls';
my Readonly $url = 'http://127.0.0.1:3000/upload';

# dates are: MM/DD/YYYY
my $query_args = { 
    # reference => C5DA9724701EEBBA95CA2CC5617BA93E4,
    # call_date => '16/08/2016'
    # recipient => 448000000000
    # start_date => '15/08/2016',
    # end_date => '25/08/2016',
    # caller_id => 441827000000,
    # number_of_calls => 3
};

my ($response_decoded, $status_code) = send_post_request($url, $query_args);

print Dumper $response_decoded;
say "response code: $status_code";

sub send_get_request {
    my ($url, $query) = @_;

    my $url_obj = URI->new($url);
    $url_obj->query_form( $query_args );

    my $rest_api = Test::RestApi->new();
    my $response = $rest_api->user_agent()->get($url_obj);
    my $status_code = $response->code();

    my $jscoder = Util::JSON->new();
    my $response_decoded = $jscoder->json_coder()->decode( $response->content() ) 
        or die "bad response: cannot decode" . $response->content();

    return ( $response_decoded, $status_code );
}

sub send_post_request {
    my ($url, $content) = @_;

    my $url_obj = URI->new($url);
    $url_obj->query_form( $query_args );

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

    my $jscoder = Util::JSON->new();
    my $response_decoded = $jscoder->json_coder()->decode( $response->content() ) 
        or die "bad response: cannot decode" . $response->content();

    return ( $response_decoded, $status_code );
}

1;