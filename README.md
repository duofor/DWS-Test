cpanm Carton
carton install

Day 1: 4h
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
    
Day 2: 4.5h
    - Completly refactored the Router module, the storage of endpoints and externalized endpoint functionality into different packages
    - /query endpoint now accepts any parameters, which are then used to query the DB. Ex: reference : abcd1234
    - Totally forgot about GIT and panic pushed all the code at once
    - Implemented retrieval of total call duration functionality for a specific period - 
        At first I made a new endpoint for this. Not sure using the /query endpoint would bring any benefit other than complexity
    - Implemented all of the initial wanted functionality, in separate endpoints.
        -> TechDebt: Reduce code duplication in each of the endpoint code -> Perhaps create a common module 
        -> TechDebt: Move queries out of Database.pm. This module should not hold queries.
        
TODO: 
    - Large file uploads
    - Handle unhappy flow in all endpoints: Ex: missing fields -> would love to have a custom error
    - Move hardcoded responses into jsons ?
    - Create unit tests for both happy/unhappy flow
    - Add 1 month limitation to requests which allow for time period
    - Add documentation.
    - Run over the code and refactor complexities (self review)
    - Support utf8 encoding ??