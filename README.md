# cabinets

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/cabinets)](https://CRAN.R-project.org/package=cabinets)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis build status](https://travis-ci.org/nt-williams/cabinets.svg?branch=master)](https://travis-ci.org/nt-williams/cabinets)
[![Codecov test coverage](https://codecov.io/gh/nt-williams/cabinets/branch/master/graph/badge.svg)](https://codecov.io/gh/nt-williams/cabinets?branch=master)
<!-- badges: end -->

*cabinets* works by writing project specific file templates to the `.Rprofile` file of the default working directory. Doing so allows the templates to be accessed in new R sessions without having to redefine them. 

*cabinets* has two main functions: `create_cabinet()` and `new_cabinet_proj()`. `create_cabinet()` constructs an R6 object of class `FileCabinet` which is then written to a `.Rprofile` file. Whenever a fresh R session is started while the default working directory, the `.Rprofile` file loads the previously created cabinet for further use. `FileCabinet` objects simply contain a template that `new_cabinate_proj()` uses to build projects with defined file structures. 

## Installation

`cabinets` can be installed using `devtools::install_github("nt-williams/cabinets")`.

### But, why? 

As a statistician, I work on different contracts with differing standard directories. 

For contract X, I might have the standard file structure: 
```
ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ data
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡   ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ derived
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡   ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬ÂÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ source
ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ code
ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ reports
ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ documents
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬ÂÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ log
```
While for contract Y, I have to work with an organization that requires I use their own system: 
```
ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Code
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡   ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ ReportsCode
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡   ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬ÂÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ AnalysisCode
ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Notes
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬ÂÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Log
```
*cabinets* results in only having to define these templates once. 

### Demo

Using the first project file structure described above, we define a new cabinet. 

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
               
#> Checking working directory... OK
#> Checking for .Rprofile... NOT FOUND: Creating .Rprofile 
#> Checking cabinet name... OK
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
                 project_name = "project_1")

#> Checking cabinet existence... OK
#> Checking if project already exits... OK
#> Creating project_1 using cabinet template: .contract_x 
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
#> ✔ Opening '/Users/nickwilliams/cabinet_test/project_1/' in new RStudio session
```

Checking the files in the newly opened project...

``` r
list.files()
#> [1] "code"            "data"            "documents"       "log"            
#> [5] "project_1.Rproj" "reports"
```



    
