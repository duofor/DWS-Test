package Util::Util;

use strict;
use warnings;

use DateTime;

sub is_time_interval_too_large {
    my ($start_date, $end_date) = @_;

    # this check should really be done in FE

    $start_date =~ /(?<day_start>\d+)\/(?<month_start>\d+)\/(?<year_start>\d+)/;
    my $start_obj = DateTime->new(
        day => $+{day_start},
        month => $+{month_start},
        year => $+{year_start}
    );

    $end_date =~ /(?<day_end>\d+)\/(?<month_end>\d+)\/(?<year_end>\d+)/;
    my $end_obj = DateTime->new(
        day => $+{day_end},
        month => $+{month_end},
        year => $+{year_end}
    );

    my $duration = $end_obj - $start_obj;

    if ( $duration->{months} > 0 ) {
        return 1;
    }

    return 0;
}

=pod 

=head1 NAME

Util::Util

=head1 DESCRIPTION

Module storing util methods.

=head1 Methods

=item * is_time_interval_too_large

Receives two dates as parameters.
Calculates duration of time between the dates.
Returns 1 if duration is greater than 1 month, 0 otherwise.

=over 4

=back

=cut

1;