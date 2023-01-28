package Router;

use Moose;
use Mojolicious::Lite -signatures;

use lib qw(.);

push app->routes->namespaces->@*, 'Routes::Controller';

(get '/query')->to('Query#process_request');

app->start('daemon');

1;