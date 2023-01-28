package Util::Database;

use Moose;
use DBI;

use Data::Dumper;

has 'dbh' => (
    is => 'ro',
    default => sub {
        my $dbh = DBI->connect("dbi:CSV:", undef, undef, {
            f_ext      => ".csv/r",
            f_dir      => 'Data',
            RaiseError => 1,
        }) or die "Cannot connect: $DBI::errstr";

        return $dbh;
    }
);

sub exec_select {
    my ($self, $params) = @_;

    my @query_params = values %$params;
    my @where_clause = ();
    foreach my $key ( keys %$params ) {
        push @where_clause, "AND $key = ?"; 
    }

    my $sql = "SELECT * " . 
        "FROM cdr " .
        "WHERE 1 = 1 " . 
        join "\n", @where_clause;
    
    print $sql . "\n";

    my $sth = $self->dbh->prepare($sql);
    $sth->execute(@query_params);

    my @result; 
    while ( my $row = $sth->fetchrow_hashref ) {
        push @result, $row;
    }

    $sth->finish();

    return \@result;
}

sub total_duration_of_calls_in_period {
    my ( $self, $params, $start_date, $end_date ) = @_;

    # call_date => 16/08/2016
    # duration => 43

    my $sql = qq { 
        SELECT *
        FROM cdr
        WHERE CALL_DATE between ? and ? 
    };
    
    my $sth = $self->dbh->prepare($sql);
    $sth->execute(@$params);

    my $stopper = 1;
    while ( my $row = $sth->fetchrow_hashref ) {
        return $row;
    }

    $sth->finish();
}


1;