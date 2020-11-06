# cabinets 0.6.0

* `new_cabinet_proj()` has a new argument, `renv = TRUE` or (`FALSE`) that optionally allows for the creation of package management infrastructure with the {renv} package. 

# cabinets 0.5.0

* new function `delete_cabinet()` for deleting cabinets without the user having to open the .Rprofile
* upon creation of a new cabinet, R no longer automatically restarts if in RStudio
* user feedback has generally been improved with the cli package
* a variety of dependencies have been removed
* creation of new RStudio projects has been handed over to the rstudioapi package

# cabinets 0.4.0

* `new_cabinet_proj()` now includes a feature for the initiation of a git repository when creating a new project.

# cabinets 0.3.2.9000

* bug fix for cabinets permission when .Rprofile already exists on first use.
* bug fix for unrecognized characters when printing cabinet structure

# cabinets 0.3.1

* `edit_r_profile()` can now be called to automatically open the .Rprofile file for editing
* CRAN policy violation resolved

# cabinets 0.2.2

* initial release on CRAN
