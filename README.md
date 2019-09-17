# cabinets

*cabinets* works by writing project specific file templates to the `.Rprofile` file of the default working directory. Doing so allows the templates to be accessed in new R sessions without having to redefine them. 

*cabinets* has two main functions: `create_cabinet()` and `new_cabinet_proj()`. `create_cabinet()` constructs an R6 object of class `FileCabinet` which is then written to a `.Rprofile` file. Whenever a fresh R session is started while the default working directory, the `.Rprofile` file loads the previously created cabinet for further use. `FileCabinet` objects simply contain a template that `new_cabinate_proj()` uses to build projects with defined file structures. 

## Installation

`cabinets` can be installed using `devtools::install_github("nt-williams/cabinets")`.

### But, why? 

As a statistician, I work on different contracts with differing standard directories. 

For contract X, I might have the standard file structure: 
```
├── data
│   ├── derived
│   └── source
├── code
├── reports
├── documents
└── log
```
While for contract Y, I have to work with an organization that requires I use their own system: 
```
├── Code
│   ├── ReportsCode
│   └── AnalysisCode
├── Notes
└── log
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
#> ✔ Opening '/Users/nickwilliams/Documents/cabinet_testing/project_1/' in new RStudio session
```
Checking the files in the newly opened project...

``` r
list.files()
#> [1] "code"            "data"            "documents"       "log"            
#> [5] "project_1.Rproj" "reports"
```



    
