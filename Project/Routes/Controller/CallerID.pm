package Routes::Controller::CallerID;

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

    if ( Util::Util::is_time_interval_too_large($params->{start_date}, $params->{end_date}) ) {
        $response = {
            Message => "Date duration exceeds 1 month",
            ErrorCode => 400 
        };
        $status_code = 400;

    } else {
        my $database = Util::Database->new();
        $response = $database->caller_id( $params );
        $status_code = 200;
    }
        
    return ($response, $status_code);
}

=pod 

=head1 NAME

Routes::Controller::CallerID

=head1 DESCRIPTION

Extends Routes::Router and implements serviceGET method

=head1 Attributes

=over 4

=head1 Methods

=over 4

=item * serviceGET

Defined route GET request behaviour. 
Processes the request and returns the response as perl data structure and the response_code

=back

=cut

1;