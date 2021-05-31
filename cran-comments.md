# What has changed in the current version 


## datagovindia 0.0.4 (Only on Github)

* Added error message for when the data.gov.in API server is down
* Added error message for when no data is returned due to incorrect api_index in get_api_data
* Added a utility to check the server - check_datagovin_server()

## datagovindia 1.0.4

* Robust error handling for server issues
* Introduced new API discovery functions to search by dates of update and creation of APIs



## local R CMD check results

### Test environments
* local x86_64-w64-mingw32, R 4.0.3 (2020-10-10) ;

R CMD check results --------------------------------- datagovindia 1.0.4 ----
Duration: 1m 48.5s

0 errors v | 0 warnings v | 0 notes v

R CMD check succeeded


## R-hub builder

### Test environments
- Ubuntu Linux 20.04.1 LTS, R-release, GCC
- Fedora Linux, R-devel, clang, gfortran

### R CMD check results

Status: OK


## win-builder

### Test environments
- using platform: x86_64-w64-mingw32 (64-bit), R version 4.0.5 (2021-03-31)
- using platform: x86_64-w64-mingw32 (64-bit), R version 4.1.0 (2021-05-18)
- using platform: x86_64-w64-mingw32 (64-bit), R Under development (unstable) (2021-05-28 r80404)


### R CMD check results
Status: OK

