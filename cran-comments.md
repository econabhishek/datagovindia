
# What has changed in the current version 


## datagovindia 0.0.4 (Only on Github)

* Added error message for when the data.gov.in API server is down
* Added error message for when no data is returned due to incorrect api_index in get_api_data
* Added a utility to check the server - check_datagovin_server()

## datagovindia 1.0.4

* Robust error handling for server issues
* Introduced new API discovery functions to search by dates of update and creation of APIs


## datagovindia 1.0.5

* Bug fixes for server-side issues like changing variable names - fixed that and resubmitted to CRAN


## local R CMD check results

### Test environments
* local x86_64-w64-mingw32, R 4.0.3 (2020-10-10) ;

-- R CMD check results ----------------------------------------------- datagovindia 1.0.5 ----
Duration: 56.1s

0 errors √ | 0 warnings √ | 0 notes √


## R-hub builder

### Test environments
- Debian Linux, R-devel, GCC
- Fedora Linux, R-devel, GCC
- aarch64-apple-darwin20 (64-bit) [ R version 4.1.1 Patched (2021-09-05 r80862) ]


### R CMD check results

Status: OK

## win-builder

### Test environments
- using platform: x86_64-w64-mingw32 (64-bit), R version 4.0.5 (2021-03-31)
- using platform: x86_64-w64-mingw32 (64-bit), R version 4.1.0 (2021-05-18)
- using platform: x86_64-w64-mingw32 (64-bit), R Under development (unstable) (2021-05-28 r80404)


### R CMD check results


Status: 1 NOTE

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Abhishek Arora <abhishek.arora1996@gmail.com>'

New submission

Package was archived on CRAN

CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2021-09-05 for policy violation.

  On Internet access.
  
Found the following (possibly) invalid URLs:
  URL: https://cran.r-project.org/package=datagovindia/vignettes/datagovindia_vignette.html
    From: README.md
    Status: 404
    Message: Not Found

Explanation :

+ The package was archived as the API changed the structure of the source data on the side of the server. It has been fixed now.

+ The URL in the note is of the vignette which is in the package's README.md file. Once the package is accepted, the URL will work. 




## Note about the package being archived 
The package ran into issues due to server side changes in how the data.gov.in API stores the data. It has been fixed now and the package is good to go.
