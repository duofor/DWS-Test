package Routes::Controller::Query;

use Moose;
use Data::Dumper;

use lib qw(.);
use Util::Database;
use Util::JSON;

extends 'Routes::Router';

sub serviceGET {
    my ($self, $params) = @_;

    my $database = Util::Database->new();
    my $response = $database->exec_select( $params );
    my $status_code = 200;

    return ($response, $status_code);
}

1;