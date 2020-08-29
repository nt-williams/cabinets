
<!-- README.md is generated from README.Rmd. Please edit that file -->

cabinets <img src='https://i.imgur.com/0QTXJ7D.png' align="right" height="139" /></a>
=====================================================================================

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/cabinets)](https://CRAN.R-project.org/package=cabinets)
![](http://cranlogs.r-pkg.org/badges/grand-total/cabinets) [![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![Travis build
status](https://travis-ci.org/nt-williams/cabinets.svg?branch=master)](https://travis-ci.org/nt-williams/cabinets)
[![Codecov test
coverage](https://codecov.io/gh/nt-williams/cabinets/branch/master/graph/badge.svg)](https://codecov.io/gh/nt-williams/cabinets?branch=master)
[![R build
status](https://github.com/nt-williams/cabinets/workflows/R-CMD-check/badge.svg)](https://github.com/nt-williams/cabinets/actions)
<!-- badges: end -->

**cabinets** makes it easy to create project specific file structure
templates that can be referenced at the start of any R session.
**cabinets** works by writing project specific file templates to the
.Rprofile file of the default working directory. Doing so allows the
templates to be accessed in new R sessions without having to redefine
them.

**cabinets** has two main functions: `create_cabinet()` and
`new_cabinet_proj()`. `create_cabinet()` constructs an R6 object of
class `FileCabinet` which is then written to a .Rprofile file. Whenever
a fresh R session is started from the default working directory, the
.Rprofile file loads the previously created cabinet for further use.

On first use, users will be prompted for explicit permission to write to
.Rprofile. Permission to write can be revoked at any time by setting the
permission option in the .Rprofile file to `FALSE`. Due to these
explicit permission requirements, `cabinets` will only work in
interactive R sessions.

Installation
------------

You can install the released version of cabinets from
[CRAN](https://CRAN.R-project.org) with:

    install.packages("cabinets")

And the development version from [GitHub](https://github.com/) with:

    # install.packages("devtools")
    devtools::install_github("nt-williams/cabinets@dev")

Motivation
----------

Different organizations, research groups, projects, etc. have different
standard directories. One organization might have the standard file
structure:

    ├── data
    │   ├── derived
    │   └── source
    ├── code
    ├── reports
    ├── documents
    └── log

While another uses a structure like this:

    ├── Code
    │   ├── ReportsCode
    │   └── AnalysisCode
    ├── Notes
    └── Log

`cabinets` makes it easy to define these templates once and then call
them for use whenever starting new projects in R.

Example
-------

A cabinet has three components: a name, a location, and a file
structure. The location defines where new directories will be created
from a cabinet template. The file structure defines, well, the structure
of this directory. We use a list to define the structure, where the name
of each list index is a unique relative path within the new directory.
Using the first project file structure described above, lets create a
new cabinet.

    loc <- "~/Desktop"

    file_str <- list(
        'data' = NULL, 
        'code' = NULL, 
        'data/derived' = NULL, 
        'data/source' = NULL, 
        'reports' = NULL, 
        'documents' = NULL, 
        'log' = NULL
    )

    create_cabinet(name = "contract", 
                   directory = loc, 
                   structure = file_str)
                   
    #> ✓ Checking for permissions
    #> ✓ Checking for .Rprofile
    #> ✓ Checking cabinet name
    #> ✓ Cabinet .contract created
    #> ● Restart R for changes to take effect
    #> ● Cabinet can be called with .contract

The cabinet is now created and doesn’t have to be redefined in future R
sessions. To examine the cabinet we just call it.

    .contract

    #> Cabinet name: contract
    #> Cabinet path: ~/Desktop
    #> Cabinet structure: 
    #> ├── data
    #> │   ├── derived
    #> │   └── source
    #> ├── code
    #> ├── reports
    #> ├── documents
    #> └── log

`new_cabinet_proj()` is then used to create a new directory from a
cabinet template.

    new_cabinet_proj(cabinet = .contract, 
                     project_name = "project", 
                     git = TRUE, 
                     git_ignore = "data")

Similar implementations
-----------------------

Similar implementations exist elsewhere. `cabinets` is unique for giving
the user the ability to design their own project templates. These are
all great packages, use what’s best for you!

-   [workflowr](https://github.com/jdblischak/workflowr)
-   [projects](https://github.com/NikKrieger/projects)
-   [starters](https://github.com/lockedata/starters)
-   [ProjectTemplate](https://github.com/KentonWhite/ProjectTemplate)

Contributing
------------

Please note that the ‘cabinets’ project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
