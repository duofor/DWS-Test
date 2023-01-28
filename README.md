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
    