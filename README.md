
    Day 1 - 4h:
        - Booted up a simple agile board in Trello
        - Spent 30minunutes reading through the given PDF and coming up with some core stuff that needs to be implemented first. 
        - Spent another 30minutes fixing path issues
        - Decided to use carton to handle package dependencies
        - Worked on a basic endpoint using Mojolicious::Lite. Decided to use Mojolicious::Lite as I always have some experience with it and its very easy to create a local endpoint
        - Added and configured a basic error response in case something goes wrong
        - Added RestApi module which for now holds a single attribute user_agent and will be the core module for making API requests
        - Added a JSON module which will help convert data structures
        - Added a Database module which uses DBD::CSV to query for cdr data
        - Configured a Controller module which is responsible for making requests to the backend.
        - Still need to find a way on how to handle big file uploads. 
            - First thoughts: If the file would be uploaded directly through the frontend, i can segment(split into chunks) the file into smaller pieces and process it on the backend.
            If the file is stored somewhere after upload, then we can simply read it and insert the new data into the DB
    
    Day 2 - 4.5h:  
        - Completly refactored the Router module, the storage of endpoints and externalized endpoint functionality into different packages
        - /query endpoint now accepts any parameters, which are then used to query the DB. Ex: reference : abcd1234
        - Totally forgot about GIT and panic pushed all the code at once
        - Implemented retrieval of total call duration functionality for a specific period - 
            At first I made a new endpoint for this. Not sure using the /query endpoint would bring any benefit other than complexity
        - Implemented all of the initial wanted functionality, in separate endpoints.
            -> TechDebt: Reduce code duplication in each of the endpoint code -> Perhaps create a common module 
            -> TechDebt: Move queries out of Database.pm. This module should not hold queries.
        
    TODO: 
        - move request code into a separate package ??
        - Large file uploads
        - Handle unhappy flow in all endpoints: Ex: missing fields -> would love to have a custom error
        - Move hardcoded responses into jsons ?
        - Create unit tests for both happy/unhappy flow
        - Add 1 month limitation to requests which allow for time period
        - Add documentation.
        - Run over the code and refactor complexities (self review)
        - Support utf8 encoding ??

    Day 3: 8h
        - Spent too much time on figuring out a json decoding issue.
        - Moved request code in different packages
        - Created a base module Router.pm which stands as base for all Controller routes.
        - Improved routes code
        - Added unit tests for all endpoints validating most of happy/unhappy flows
        - Added pod documentation
        - Decided not to create jsons for backend.
        - Added month limitation to requests to allow for time period
        - Created an endpoint to handle basic file uploads. 
            As a future improvement, splitting file in lower sized chunks would serve as a good solution when downloading big files
        - Fixed bugs and tested the endpoints.
        - Worked on documentation

    Setup: 
    cpanm Carton
    carton install

    Starting the mojolicious server locally:
        - Open terminal and go to your home directory
        - cd DWS-Test\Project
        - perl CdrApp.pm
    
    Running the test suite:
        - Open terminal and go to your home directory
        - cd DWS-Test\Project
        - carton exec -- prove -v Test\t\* --verbose > test.txt
        - Test output will be redirected into a new file test.txt located in your home directory.


    Server endpoint documentation:

    GET /query
        - Endpoint used to retrieve individual CDR by the CDR reference.
        - For testing purposes I implemented it in such way that it is able to take any key : value pair and query the DB for it.
        -Response: the full CDR as JSON

    GET /total
        - Accepts start_date, end_date and type as params
        - Queries the DB for total duration of calls between start_date and end_date
        - Allows for additional fintering based on type param
        - Response as JSON: 
            total_call_duration is the total call duration of calls between the given perioid
            total_number_of_calls is the number of calls between the given perioid
    
    GET /caller_id
        - Accepts caller_id, start_date, end_date and type as params
        - Queries the DB for all CDRs of caller_id param within the given time period
        - Allows for additional fintering based on type param 
        - Response contains all CDRs for the specific caller_id in the given period, as JSON.

    GET /calls
        - Accepts caller_id, start_date, end_date, number_of_calls and type as params
        - number_of_calls param represents the number of most expensive calls wanted to be returned in the response
        - Allows for additional fintering based on type param 
        - Response contains the <number_of_calls> most expensive calls(CDRs) for the specific caller_id within the given time period

    POST /upload
        - Accepts a file 
        - The file is downloaded into a local csv with a static name, it is read and then inserted into the local DB.
        - Response as JSON:
            OnSuccess - { "Message" : "Success" } , 200
            OnFail - server error, 400


    Enhancements i would love to do:
        - Make a simple user interface which allows for an upload and has a form which automately perform the requests.
        - Currently using DBD::CSV as database, would love to move to an SQL server.
        - Add unit tests for local modules.
        - Extend error handling for mandatory/non-mandatory fields. A json schema for each endpoint would be amazing
        - Move from Mojolicious::Lite to Mojolicious
        - Add an aditional user agent: Mojo::UserAgent, so that server start is no longer needed(if ran locally). Helps debugging
        - Improve RestApi module to expand request settings
        - Add a cURL role which outputs request/responses as cURL so that its easy to share requests with other people
        - Remove code duplication from unit tests
        - Polish the code a little more
        - Improve documentation
