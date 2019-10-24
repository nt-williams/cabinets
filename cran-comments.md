## Resubmission

This is a resubmission; in this version (0.2.2) I have: 

* eliminated the use of cat() across all functions outside of print() in FileCabinet()

## Test environments

* local OS X install, R 3.6.1
* local Windows, R 3.6.1
* ubuntu 14.04 (on travis-ci), R 3.6.1

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Downstream dependencies

There are no downstream dependencies

## Other

Addressing CRAN policy on writing to user's home filespace: 

* A strong effort has been made to be transparent that cabinets works by writing to a .Rprofile file. 
* On first use, cabinets requires explicit user permission to write to or create a .Rprofile file. 
* Without this permission, the package will not work. 
* Instructions are also placed in the documentation for how to revoke this permission. 
* For these reasons, cabinets will also not work in non-interactive sessions. 
