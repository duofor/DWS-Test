package Routes::Controller::Upload;

use Moose;
use Data::Dumper;
use Cwd qw(cwd);

use lib qw(.);
use Util::Database;
use Util::JSON;

extends 'Routes::Router';

sub servicePOST {
    my ($self, $params) = @_;

    my $home = cwd();
    my $response;
    my $status_code;

    my $uploaded_file = $self->req->uploads()->[0];
    $uploaded_file->move_to("$home/Data/cdr_downloaded_test.csv");

    if ( $self->dump_to_db() ){
        $response = '{ "Message" : "Success" }';
        $status_code = 200;
    } else {
        die; # handle with some message?
    }

    return ($response, $status_code);
}

sub dump_to_db {
    my ($self) = @_;

    my $sql = q{
        INSERT INTO cdr 
            ( caller_id,recipient,call_date,end_time,duration,cost,reference,currency,type )
        VALUES
            ( ?, ?, ?, ?, ?, ?, ?, ?, ? )
    };

    my $database = Util::Database->new();
    my $sth = $database->dbh->prepare($sql);

    my $file_head = 'caller_id,recipient,call_date,end_time,duration,cost,reference,currency,type';
    my $counter = 0;

    open (my $fh, '<', 'Data/cdr_downloaded_test.csv');

    while ( my $line = <$fh> ) {
        die if $counter == 0 && $line !~ /$file_head/; 
        $counter = 1;
        next if $line =~ /$file_head/;

        chomp $line;
        my @params = split /,/, $line;
        
        $sth->execute( @params );
    }

    $sth->finish();

    return 1;
}

=pod 

=head1 NAME

Routes::Controller::Upload

=head1 DESCRIPTION

Extends Routes::Router and implements servicePOST method

=head1 Attributes

=over 4

=head1 Methods

=over 4

=item * servicePOST

Defined route POST request behaviour.
Downloads the file provided and dumps its content into the Database cdr table.


=back

=cut

1;