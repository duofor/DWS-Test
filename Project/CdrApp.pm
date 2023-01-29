package CdrApp;

use Moose;
use Mojolicious::Lite -signatures;

use lib qw(.);

push app->routes->namespaces->@*, 'Routes::Controller';

(get '/query')->to('Query#process_request');
(get '/total')->to('TotalCallDuration#process_request');
(get '/caller_id')->to('CallerID#process_request');
(get '/calls')->to('GetCalls#process_request');

app->start('daemon');

1;