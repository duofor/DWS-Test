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
        - carton exec -- prove -v Test\t\* > test.txt
        - Test output will be redirected into a new file test.txt located in your home directory.


    Server endpoint documentation:

    GET /query
        - Endpoint used to retrieve individual CDR by the CDR reference.
        - For testing purposes I implemented it in such way that it is able to take any key : value pair and query the DB for it.
        -Response: the full CDR as JSON

    GET /total
        - Accepts start_date, end_date and type as params
        - Queries the DB for total duration of calls between start_date and end_date
        - Allows for additional filtering based on type param
        - Response as JSON: 
            total_call_duration is the total call duration of calls between the given perioid
            total_number_of_calls is the number of calls between the given perioid
    
    GET /caller_id
        - Accepts caller_id, start_date, end_date and type as params
        - Queries the DB for all CDRs of caller_id param within the given time period
        - Allows for additional filtering based on type param 
        - Response contains all CDRs for the specific caller_id in the given period, as JSON.

    GET /calls
        - Accepts caller_id, start_date, end_date, number_of_calls and type as params
        - number_of_calls param represents the number of most expensive calls wanted to be returned in the response
        - Allows for additional filtering based on type param 
        - Response contains the <number_of_calls> most expensive calls(CDRs) for the specific caller_id within the given time period

    POST /upload
        - Accepts a file 
        - The file is downloaded into a local csv with a static name, it is read and then inserted into the local DB.
        - Response as JSON:
            OnSuccess - { "Message" : "Success" } , 200
            OnFail - server error, 400

