package Util::JSON;

use Moose;
use Cpanel::JSON::XS;

has 'json_coder' => (
    is => 'ro',
    default => sub {
        return Cpanel::JSON::XS->new->utf8->pretty;
    }
);

=pod 

=head1 NAME

Util::JSON

=head1 DESCRIPTION

Module responsible for encode/decode operation on JSON files

=head1 Attributes

=item * json_coder
  
Returns a readonly instance of Cpanel::JSON::XS

=over 4

=head1 Methods

=over 4

=back

=cut

1;