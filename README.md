# cabinets

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/cabinets)](https://CRAN.R-project.org/package=cabinets)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

*cabinets* works by writing project specific file templates to the `.Rprofile` file of the default working directory. Doing so allows the templates to be accessed in new R sessions without having to redefine them. 

*cabinets* has two main functions: `create_cabinet()` and `new_cabinet_proj()`. `create_cabinet()` constructs an R6 object of class `FileCabinet` which is then written to a `.Rprofile` file. Whenever a fresh R session is started while the default working directory, the `.Rprofile` file loads the previously created cabinet for further use. `FileCabinet` objects simply contain a template that `new_cabinate_proj()` uses to build projects with defined file structures. 

## Installation

`cabinets` can be installed using `devtools::install_github("nt-williams/cabinets")`.

### But, why? 

As a statistician, I work on different contracts with differing standard directories. 

For contract X, I might have the standard file structure: 
```
â”œâ”€â”€ data
â”‚   â”œâ”€â”€ derived
â”‚   â””â”€â”€ source
â”œâ”€â”€ code
â”œâ”€â”€ reports
â”œâ”€â”€ documents
â””â”€â”€ log
```
While for contract Y, I have to work with an organization that requires I use their own system: 
```
â”œâ”€â”€ Code
â”‚   â”œâ”€â”€ ReportsCode
â”‚   â””â”€â”€ AnalysisCode
â”œâ”€â”€ Notes
â””â”€â”€ log
```
*cabinets* results in only having to define these templates once. 

### Demo

Using the first project file structure described above, we define a new cabinet. 

``` r
file_str <- list(
    'data' = NULL, 
    'code' = NULL, 
    'data/derived' = NULL, 
    'data/source' = NULL, 
    'reports' = NULL, 
    'documents' = NULL, 
    'log' = NULL
)

cab_location <- file.path(path.expand("~"), "Documents", "cabinet_testing")

cabinets::create_cabinet(name = "contract_x", 
                         directory = cab_location, 
                         structure = file_str)
#> Checking working directory... OK
#> Checking for .Rprofile...
#> NOT FOUND: Creating .Rprofile
#> Checking for .FileCabinet...
#> NOT FOUND: Writing .FileCabinet to .Rprofile
#> Checking cabinet name... OK
#> Cabinet, .contract_x created. Restarting R. 
#> Cabinet can be called using: .contract_x
#> 
#> Restarting R session...
```
The cabinet is now created and doens't have to be redfined in future R sessions. 

``` r
cabinets::new_cabinet_proj(cabinet = .contract_x, 
                           project_name = "project_1")
#> Checking cabinet existence... OK
#> Checking if project already exits... OK
#> Creating project_1 using cabinet template .contract_x
#> Opening new R project, project_1
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
#> 
#> âœ” Opening '/Users/nickwilliams/Documents/cabinet_testing/project_1/' in new RStudio session
```
Checking the files in the newly opened project...

``` r
list.files()
#> [1] "code"            "data"            "documents"       "log"            
#> [5] "project_1.Rproj" "reports"
```



    
