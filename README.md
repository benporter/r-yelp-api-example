# r-yelp-api-example
An example of how to query the Yelp API

This code is a simplified version of the Yelp "search" API
https://github.com/Yelp/yelp-api/blob/master/v2/r/sample.R

Install the necessary packages

    install.packages("readr")
    install.packages("httr")
    install.packages("httpuv")
    install.packages("jsonlite")
    install.packages("base64enc")

Load the libraries

    library(readr)
    library(httr)
    library(httpuv)
    library(jsonlite)
    library(base64enc)

Go to <a href="https://www.yelp.com/developers">https://www.yelp.com/developers</a> and request an api key.  Rather than hard coding my keys into the code, I saved it to a file, *yelpapikeys.txt*.  The following code uses the function to read tab separated data from **readr** package.

    keys <- read_tsv("~/Documents/yelp/yelpapikey.txt",col_names = c("type","value"))

Extract all of the values from that keys files.

    client_id     <- keys$value[keys$type=="Consumer Key"]
    client_secret <- keys$value[keys$type=="Consumer Secret"]
    token         <- keys$value[keys$type=="Token"]
    token_secret  <- keys$value[keys$type=="Token Secret"]

Define the app using the Consumer Key and Consumer Secret.  Then sign the app using the Token and Token Secret.

    myapp <- oauth_app("YELP",
                   key = client_id,
                   secret = client_secret)
    sig <-sign_oauth1.0(myapp,token=token, 
                    token_secret=token_secret)

This step is where you define what you are searching for on Yelp.  For more options, see the <a href="https://www.yelp.com/developers/documentation/v2/search_api">Yelp Search API</a> documentation.

    args <- list(term="Vietnamese",location="Charlotte, NC",limit=20)

Query the API, storing the results in the *result* object.  Note that GET() is capitalized.

    result <- GET("https://api.yelp.com/v2/search/", sig, query=args)
    
Convert the results to a dataframe and print the first 6 records.

    df <- fromJSON(toJSON(content(result)))
    head(df)

