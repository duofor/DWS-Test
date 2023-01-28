package Util::JSON;

use Moose;
use JSON::XS;

has 'json_coder' => (
    is => 'ro',
    default => sub {
        return JSON::XS->new->utf8->pretty;
    }
);

1;