package Util::RestUtil;

use Moose;

sub _get_server_error_response_json {
  my $path = Mojo::File->new('Test/json/error.json');
  my $error_json = $path->slurp;
  
  return $error_json;
}

1;
