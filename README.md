
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datagovindia

**datagovindia** is a wrapper around \>80,000 APIS of the Government of
India’s open data platform [data.gov.in](https://data.gov.in/ogpl_apis).
Here is a small guide to take you thorugh the package. Primarily,the
functionality is centered around three aspects :

  - **API discovery** - Finding the right API from all the available
    APIs
  - **API information** - Getting information about a particular API
  - **Querying the API** - Getting a tidy data set from the chosen API

## Installation

You can install the development version from
[GitHub](https://github.com/econabhishek/datagovindia) with:

``` r
# install.packages("devtools")
devtools::install_github("econabhishek/datagovindia")
```

## Prequisites

  - An account on data.gov.in
  - An API key from the My Account page (instructions here : [official
    guide](https://data.gov.in/help/how-use-datasets-apis))

## Setup

``` r
library(datagovindia)

#Validate your API key
```

Know more about the various functions in the package [vignette](LINK)

## Example workflow

Once you have the API key ready, and have chosen the API you want and
have its index\_name ([vignette](LINK) for more details) using the
search functions in the package, you are ready to extract data from it.

The function *get\_api\_data* is really the powerhouse in this package
which allows one to do things over and above a manually constructed API
query can do by utilizing the data.frame structure of the underlying
data. It allows the user to filter, sort, select variables and to decide
how much of the data to extract. The website can itself filter on only
one field with one value at a time but one command through the wrapper
can make multiple requests and append the results from these requests at
the same time.

But before we dive into data extraction, we first need to validate our
API key relieved from [data.gov.in](https://data.gov.in/ogpl_apis). To
get the key, you need to register first register and then get the key
from your “My Account” page after logging in. More instruction can be
found on this [official
guide](https://data.gov.in/help/how-use-datasets-apis). Once you get
your API key, you can validate it as follows (only need to do this once
per session, this is a sample key from the website for demonstration) :

``` r
##Using a sample key
register_api_key("579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b")
#> Connected to the internet
#> The API key is valid and you won't have to set it again
```

Once you have your key registered, you are ready to extract data from a
chosen API. Here is what each argument means :

  - api\_index : index\_name of the chosen API (found by using search
    functions)
  - results\_per\_req : Results per request sent to the server ; can
    take integer values or the string “all” to get all of the available
    data
  - filter\_by : A named character vector of field id (not the name) -
    value(s) pairs ; can take multiple fields as well as multiple comma
    separated values
  - field\_select : A character vector of fields to select only a subset
    of variables in the final data.frame
  - sort\_by : Sort by one or multiple fields

In a nutshell, first find the API you want using the search functions,
get the **index\_name** of the API from the results, optionally take a
look at the fields present in the data of the API and then use the
get\_api\_data function to extract the data. Suppose we choose the API
“Real time Air Quality Index from various location” with index\_ name
*3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69*. First we will look at which
fields are available to construct the right query.  
Suppose We want to get the data from only 2 cities Chandigarh and
Gurugram and pollutants PM10 and NO2. We will let all fields to be
returned (dataset columns).

We now look at the fields available to play with.

``` r
get_api_fields("3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69")
```

| id              | name            | type    |
| :-------------- | :-------------- | :------ |
| document\_id    | document\_id    | double  |
| id              | id              | double  |
| country         | country         | keyword |
| state           | state           | keyword |
| city            | city            | keyword |
| station         | station         | keyword |
| last\_update    | last\_update    | date    |
| pollutant\_id   | pollutant\_id   | keyword |
| pollutant\_min  | pollutant\_min  | double  |
| pollutant\_max  | pollutant\_max  | double  |
| pollutant\_avg  | pollutant\_avg  | double  |
| pollutant\_unit | pollutant\_unit | keyword |
| resource\_uuid  | resource\_uuid  | keyword |

We accordingly select the **city** and **pollution\_id** fields for
constructing our query. Note that we use only field id to finally query
the data.

``` r

get_api_data(api_index="3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69",
             results_per_req=10,filter_by=c(city="Gurugram,Chandigarh",
                                            polutant_id="PM10,NO2"),
             field_select=c(),
             sort_by=c('state','city'))
#> Connected to the internet
#> url-https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b&format=json&offset=0&limit=10&filters[city]=Gurugram&filters[polutant_id]=PM10
#> gave the API a rest
#> url-https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b&format=json&offset=0&limit=10&filters[city]=Chandigarh&filters[polutant_id]=PM10
#> gave the API a rest
#> url-https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b&format=json&offset=0&limit=10&filters[city]=Gurugram&filters[polutant_id]=NO2
#> gave the API a rest
#> url-https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b&format=json&offset=0&limit=10&filters[city]=Chandigarh&filters[polutant_id]=NO2
#> gave the API a rest
```

| id  | country | state      | city       | station                       | last\_update        | pollutant\_id | pollutant\_min | pollutant\_max | pollutant\_avg | pollutant\_unit |
| :-- | :------ | :--------- | :--------- | :---------------------------- | :------------------ | :------------ | :------------- | :------------- | :------------- | :-------------- |
| 454 | India   | Haryana    | Gurugram   | Sector-51, Gurugram - HSPCB   | 07-04-2021 10:00:00 | PM10          | 155            | 500            | 340            | NA              |
| 461 | India   | Haryana    | Gurugram   | Teri Gram, Gurugram - HSPCB   | 07-04-2021 10:00:00 | PM10          | 114            | 448            | 220            | NA              |
| 120 | India   | Chandigarh | Chandigarh | Sector-25, Chandigarh - CPCC  | 07-04-2021 10:00:00 | PM10          | 105            | 500            | 225            | NA              |
| 455 | India   | Haryana    | Gurugram   | Sector-51, Gurugram - HSPCB   | 07-04-2021 10:00:00 | NO2           | 16             | 23             | 18             | NA              |
| 462 | India   | Haryana    | Gurugram   | Teri Gram, Gurugram - HSPCB   | 07-04-2021 10:00:00 | NO2           | 10             | 23             | 16             | NA              |
| 468 | India   | Haryana    | Gurugram   | Vikas Sadan, Gurugram - HSPCB | 07-04-2021 10:00:00 | NO2           | 12             | 139            | 58             | NA              |
| 121 | India   | Chandigarh | Chandigarh | Sector-25, Chandigarh - CPCC  | 07-04-2021 10:00:00 | NO2           | 17             | 109            | 44             | NA              |
