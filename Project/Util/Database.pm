package Util::Database;

use Moose;
use DBI;

use Data::Dumper;
use DateTime;

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
    my ( $self, $params ) = @_;

    my @where_clause = ( "AND CALL_DATE BETWEEN (?, ?)" );
    my @query_params = ( $params->{start_date}, $params->{end_date} );

    if ( defined $params->{type} ) {
        push @where_clause, "AND TYPE = ?";
        push @query_params, $params->{type}; 
    }

    my $sql = "SELECT duration " .
        "FROM cdr " .
        "WHERE 1 = 1 " .
        join "\n", @where_clause;

    my $sth = $self->dbh->prepare($sql);
    $sth->execute(@query_params);

    my @result;
    while ( my $row = $sth->fetchrow_hashref ) {
        next unless $row->{duration};
        next unless $row->{duration} =~ /^\d+$/;

        push @result, $row->{duration};
    }

    $sth->finish();

    return \@result;
}

sub caller_id {
    my ( $self, $params ) = @_;

    my @where_clause = ( "AND CALL_DATE BETWEEN (?, ?)" );
    my @query_params = ( $params->{start_date}, $params->{end_date} );

    push @where_clause, "AND CALLER_ID = ?";
    push @query_params, $params->{caller_id};

    if ( defined $params->{type} ) {
        push @where_clause, "AND TYPE = ?";
        push @query_params, $params->{type}; 
    } 

    my $sql = "SELECT * " .
        "FROM cdr " .
        "WHERE 1 = 1 " .
        join "\n", @where_clause;

    my $sth = $self->dbh->prepare($sql);
    $sth->execute(@query_params);

    my @result;
    while ( my $row = $sth->fetchrow_hashref ) {
        push @result, $row;
    }

    $sth->finish();

    return \@result;
}

sub most_expensive_calls {
    my ( $self, $params ) = @_;

    my @where_clause = ( "AND CALL_DATE BETWEEN (?, ?)" );
    my @query_params = ( $params->{start_date}, $params->{end_date} );

    push @where_clause, "AND CALLER_ID = ?";
    push @query_params, $params->{caller_id};

    if ( defined $params->{type} ) {
        push @where_clause, "AND TYPE = ?";
        push @query_params, $params->{type}; 
    } 

    my $sql = "SELECT * " .
        "FROM cdr " .
        "WHERE 1 = 1 " .
        join "\n", @where_clause, .
        " ORDER BY cost ASC";

    print $sql;
    print join ',', @query_params;

    my $sth = $self->dbh->prepare($sql);
    $sth->execute(@query_params);

    my @result;
    my $rownum = $params->{number_of_calls};
    my $counter = 0;
    while ( my $row = $sth->fetchrow_hashref ) {
        last if $counter >= $rownum;
        $counter++;

        push @result, $row;
    }

    $sth->finish();

    return \@result;
}

1;