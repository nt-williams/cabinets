# cabinets <img src='man/figures/logo.png' align="right" height="138.5" />

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/cabinets)](https://CRAN.R-project.org/package=cabinets)
![](http://cranlogs.r-pkg.org/badges/grand-total/cabinets)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![Travis build status](https://travis-ci.org/nt-williams/cabinets.svg?branch=master)](https://travis-ci.org/nt-williams/cabinets)
[![Codecov test coverage](https://codecov.io/gh/nt-williams/cabinets/branch/master/graph/badge.svg)](https://codecov.io/gh/nt-williams/cabinets?branch=master)
<!-- badges: end -->

`cabinets` makes it easy to create project specific file structure templates that can be referenced at the start of any R session without having to redefine them. The goal is to encourage reproducibility by automating some of the work that being reproducible requires. 

`cabinets` has two main functions: `create_cabinet()` and `new_cabinet_proj()`. `create_cabinet()` constructs an R6 object of class `FileCabinet` which is then written to a `.Rprofile` file. Whenever a fresh R session is started from the default working directory, the `.Rprofile` file loads previously created cabinets for further use. `FileCabinet` objects simply contain a template that `new_cabinet_proj()` uses to build projects with pre-defined file structures and locations. 

## Installation

`cabinets` can be installed from CRAN using: 

```
install.packages("cabinets")
```

The development version can be installed from github using:

```
devtools::install_github("nt-williams/cabinets")
```

## Motivation

Reproducibility takes effort. `cabinets` seeks to cut down on this effort by automating one of the layers of reproducibility---project organization. In addition, not everyone should be forced to use the same template for a project. If something works best for you, you should use it. `cabinets` was developed with this in mind. 

For example, a statistician might have the following standard project structure: 

```
├── data
│   ├── derived
│   └── source
├── code
├── reports
├── documents
└── log
```

This template can be defined in R using `cabinets`. This prevents having to copy and paste pre-exisiting projects to start new ones or relying on a github repo that only contains empty folders. 

## Demo

Using the project file structure described above, we define a new cabinet: 

``` r
cabinet_loc <- "~/cabinet_test"

cabinet_str <- list(
    'data' = NULL, 
    'code' = NULL, 
    'data/derived' = NULL, 
    'data/source' = NULL, 
    'reports' = NULL, 
    'documents' = NULL, 
    'log' = NULL
)

create_cabinet(name = "contract_x", 
               directory = cabinet_loc, 
               structure = cabinet_str)
               
#> Permission granted.
#> Checking for .Rprofile...
#> .Rprofile not found.
#> Creating .Rprofile...
#> Checking cabinet name... 
#> Cabinet .contract_x created... Restarting R.
#> Cabinet can be called using: .contract_x
#> 
#> Restarting R session...
```

The cabinet is now created and doesn't have to be redfined in future R sessions. To examine the cabinet we just call it.

``` r
.contract_x

#> Cabinet name: contract_x
#> Cabinet path: ~/cabinet_test
#> Cabinet structure: 
#> ├── data
#> │   ├── derived
#> │   └── source
#> ├── code
#> ├── reports
#> ├── documents
#> └── log
```

`new_cabinet_proj()` is used to create a new directory from a cabinet template.

``` r
new_cabinet_proj(cabinet = .contract_x, 
                 project_name = "project_1", 
                 git = TRUE, 
                 git_ignore = "data")

#> Checking cabinet existence...
#> Checking if project already exists...
#> Creating project_1 using cabinet template: .contract_x 
#> Checking for git configuration... 
#> Git repository initiated in ~/project_1
#> 
#> R project settings:
#> 
#> Version: 1.0
#> RestoreWorkspace: No
#> SaveWorkspace: No
#> AlwaysSaveHistory: Default
#> EnableCodeIndexing: Yes
#> UseSpacesForTab: Yes
#> NumSpacesForTab: 2
#> Encoding: UTF-8
#> RnwWeave: Sweave
#> LaTeX: pdfLaTeX
#> AutoAppendNewline: Yes
#> StripTrailingWhitespace: Yes 
#> Opening new R project, project_1
#> 
#> ✔ Opening '/Users/nickwilliams/cabinet_test/project_1/' in new RStudio session
```

## Similiar implementations

Similiar implementations exist elsewhere. `cabinets` is unique however for giving the user the true ability to design their own project templates. 

The following list of R packages contain similiar implementations: 

* [workflowr](https://github.com/jdblischak/workflowr)
* [projects](https://github.com/NikKrieger/projects)
* [starters](https://github.com/lockedata/starters)
* [ProjectTemplate](https://github.com/KentonWhite/ProjectTemplate)

## Contributing

Please note that the 'cabinets' project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.

