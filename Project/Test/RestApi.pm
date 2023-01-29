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

=pod 

=head1 NAME

Test::RestApi

=head1 DESCRIPTION

Provides Rest Api tools

=head1 Attributes

=item * user_agent

Attribute holding the user agent.
Can be extended to use different user agents  

=over 4

=head1 Methods

=over 4

=back

=cut

1;