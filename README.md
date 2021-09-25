
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datagovindia

**datagovindia** is a wrapper around \>100,000 APIs of the Government of
India’s open data platform [data.gov.in](https://data.gov.in/ogpl_apis).
Here is a small guide to take you through the package. Primarily,the
functionality is centered around three aspects :

  - **API discovery** - Finding the right API from all the available
    APIs
  - **API information** - Getting information about a particular API
  - **Querying the API** - Getting a tidy data set from the chosen API

## Installation

The package is now on CRAN, download using :

``` r
install.packages("datagovindia")
```

You can install the development version from
[GitHub](https://github.com/econabhishek/datagovindia) with:

``` r
# install.packages("devtools")
devtools::install_github("econabhishek/datagovindia")
```

## Prerequisites

  - An account on data.gov.in
  - An API key from the My Account page (instructions here : [official
    guide](https://data.gov.in/help/how-use-datasets-apis))

## Setup

``` r
library(datagovindia)
```

Know more about the various functions in the package
[**vignette**](https://cran.r-project.org/package=datagovindia/vignettes/datagovindia_vignette.html).

## Example workflow

Once you have the API key ready, and have chosen the API you want and
have its index\_name
([**vignette**](https://cran.r-project.org/package=datagovindia/vignettes/datagovindia_vignette.html)
for more details) using the search functions in the package, you are
ready to extract data from it.

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
#> The server is online
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

| id             | name           | type    |
| :------------- | :------------- | :------ |
| document\_id   | document\_id   | double  |
| id             | id             | double  |
| country        | country        | keyword |
| state          | state          | keyword |
| city           | city           | keyword |
| station        | station        | keyword |
| pollutant\_id  | pollutant\_id  | keyword |
| last\_update   | last\_update   | date    |
| pollutant\_min | pollutant\_min | double  |
| pollutant\_max | pollutant\_max | double  |
| pollutant\_avg | pollutant\_avg | double  |
| resource\_uuid | resource\_uuid | keyword |

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
#> The server is online
#> url-https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b&format=json&offset=0&limit=10&filters[city]=Gurugram&filters[polutant_id]=PM10
#> gave the API a rest
#> url-https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b&format=json&offset=0&limit=10&filters[city]=Chandigarh&filters[polutant_id]=PM10
#> gave the API a rest
#> url-https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b&format=json&offset=0&limit=10&filters[city]=Gurugram&filters[polutant_id]=NO2
#> gave the API a rest
#> url-https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b&format=json&offset=0&limit=10&filters[city]=Chandigarh&filters[polutant_id]=NO2
#> gave the API a rest
#> No results returned - check your api_index
```

| id  | country | state      | city       | station                          | pollutant\_id | last\_update        | pollutant\_min | pollutant\_max | pollutant\_avg |
| :-- | :------ | :--------- | :--------- | :------------------------------- | :------------ | :------------------ | :------------- | :------------- | :------------- |
| 550 | India   | Haryana    | Gurugram   | NISE Gwal Pahari, Gurugram - IMD | PM10          | 25-09-2021 05:00:00 | 22             | 102            | 50             |
| 555 | India   | Haryana    | Gurugram   | Sector-51, Gurugram - HSPCB      | PM10          | 25-09-2021 05:00:00 | 59             | 119            | 81             |
| 562 | India   | Haryana    | Gurugram   | Teri Gram, Gurugram - HSPCB      | PM10          | 25-09-2021 05:00:00 | 36             | 100            | 61             |
| 103 | India   | Chandigarh | Chandigarh | Sector 22, Chandigarh - CPCC     | PM10          | 25-09-2021 05:00:00 | 13             | 102            | 49             |
| 110 | India   | Chandigarh | Chandigarh | Sector-25, Chandigarh - CPCC     | PM10          | 25-09-2021 05:00:00 | 19             | 84             | 42             |
| 551 | India   | Haryana    | Gurugram   | NISE Gwal Pahari, Gurugram - IMD | NO2           | 25-09-2021 05:00:00 | 13             | 25             | 17             |
| 556 | India   | Haryana    | Gurugram   | Sector-51, Gurugram - HSPCB      | NO2           | 25-09-2021 05:00:00 | 8              | 13             | 10             |
| 563 | India   | Haryana    | Gurugram   | Teri Gram, Gurugram - HSPCB      | NO2           | 25-09-2021 05:00:00 | 8              | 10             | 8              |
| 569 | India   | Haryana    | Gurugram   | Vikas Sadan, Gurugram - HSPCB    | NO2           | 25-09-2021 05:00:00 | 17             | 40             | 28             |
| 104 | India   | Chandigarh | Chandigarh | Sector 22, Chandigarh - CPCC     | NO2           | 25-09-2021 05:00:00 | 15             | 83             | 42             |
| 111 | India   | Chandigarh | Chandigarh | Sector-25, Chandigarh - CPCC     | NO2           | 25-09-2021 05:00:00 | 4              | 29             | 13             |

## **Python Version**

This wrapper is also available on Python (PyPI) visit -

  - [Development version](https://github.com/addypy/datagovindia)

  - [PyPI](https://pypi.org/project/datagovindia/)

Use

``` python
pip install datagovindia
```

Authors :

  - [Abhishek Arora](https://github.com/econabhishek)
  - [Aditya Karan Chhabra](https://github.com/addypy)
