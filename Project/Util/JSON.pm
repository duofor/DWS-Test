package Util::JSON;

use Moose;
use Cpanel::JSON::XS;

has 'json_coder' => (
    is => 'ro',
    default => sub {
        return Cpanel::JSON::XS->new->utf8->pretty;
    }
);

1;