
#https://github.com/Yelp/yelp-api/blob/master/v2/r/sample.R

#install.packages("readr")
#install.packages("httr")
#install.packages("httpuv")
#install.packages("jsonlite")
#install.packages("base64enc")

library(readr)
library(httr)
library(httpuv)
library(jsonlite)
library(base64enc)

# saved file of this page:  https://www.yelp.com/developers/manage_api_keys
keys <- read_tsv("~/Documents/yelp/yelpapikey.txt",col_names = c("type","value"))

# extract the values from the file
client_id     <- keys$value[keys$type=="Consumer Key"]
client_secret <- keys$value[keys$type=="Consumer Secret"]
token         <- keys$value[keys$type=="Token"]
token_secret  <- keys$value[keys$type=="Token Secret"]

myapp <- oauth_app("YELP",
                   key = client_id,
                   secret = client_secret)

sig <-sign_oauth1.0(myapp,token=token, 
                    token_secret=token_secret)

args <- list(term="Vietnamese",location="Charlotte, NC",limit=20)

result <- GET("https://api.yelp.com/v2/search/", sig, query=args)

df <- fromJSON(toJSON(content(result)))
head(df)
