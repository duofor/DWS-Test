package Test::RestApi;

use Moose;
use LWP::UserAgent;

has 'user_agent' => (
    is => 'ro',
    isa => 'LWP::UserAgent',
    default => sub {
        return LWP::UserAgent->new(
            timeout => 10,
            agent => 'Mozilla/5.0'
        );
    }
);

1;