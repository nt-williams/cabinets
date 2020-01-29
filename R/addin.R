
available_cabinets <- function() {
    hidden <- as.list(ls(all.names = TRUE, envir = .GlobalEnv))
    classes <- lapply(hidden, function(x) class(eval(parse(text = x))))

    if (any(sapply(classes, function(x) "FileCabinet" %in% x))) {
        available <- list()
        for (i in seq_along(classes)) {
            if ("FileCabinet" %in% classes[[i]]) available[[i]] <- hidden[[i]]
        }
        available <- unlist(available)
    } else {
        available <- message("No cabinets found. Cabinets can be created using create_cabinets().")
    }

    return(available)
}

cabinets_gadget <- function() {

    ui <- miniUI::miniPage(
        miniUI::gadgetTitleBar("Cabinets"),
        shinyjs::useShinyjs(),
        miniUI::miniTabstripPanel(
            id = "project",
            miniUI::miniTabPanel(
                title = "Create a cabinet",
                icon = shiny::icon("archive"),
                shiny::fillRow(
                    miniUI::miniContentPanel(
                        shiny::textInput(
                            "cabinet_name",
                            "Choose a cabinet name",
                            placeholder = "ex. contractX",
                            width = "100%"
                        ),
                        shiny::tags$p(
                            "Please choose the directory for where the cabinet will exist. This is where
                            project created using the cabinet will be located on your system."
                        ),
                        shinyFiles::shinyDirButton(
                            "directory",
                            "Select directory",
                            "Please select a directory"
                        )
                    ),
                    miniUI::miniContentPanel(
                        shiny::textInput(
                            "structure",
                            "Create the cabinet structure",
                            width = "100%",
                            placeholder = "ex. data/source"
                        ),
                        shiny::actionButton("add", "Add to template"),
                        shiny::br(),
                        shiny::helpText(shiny::a("Click here for help with creating a cabinet structure",
                                                 href = "https://github.com/nt-williams/cabinets",
                                                 target="_blank"))
                    )
                )
            ),
            miniUI::miniTabPanel(
                title = "Start a new project",
                icon = shiny::icon("folder"),
                shiny::fillRow(
                    miniUI::miniContentPanel(
                        shiny::selectizeInput(
                            "select_cabinet",
                            "Select cabinet",
                            choices = c("Please select a cabinet...", available_cabinets()),
                            width = "100%"
                        ),
                        shiny::textInput(
                            "project_name",
                            "Project name",
                            value = "Enter project name...",
                            width = "100%"
                        )),
                    miniUI::miniContentPanel(
                        shiny::checkboxInput(
                            "rproj",
                            "R Project",
                            value = TRUE
                        ),
                        shiny::conditionalPanel(
                            condition = "input.rproj == true",
                            shiny::checkboxInput(
                                "open",
                                "Open R Project",
                                value = TRUE
                            )
                        ),
                        shiny::checkboxInput(
                            "git",
                            "Git",
                            value = TRUE
                        ),
                        shiny::tags$p(
                            "The default directory for the git repository is is the root of the project.
                            However you change it to be one of the project subdirectories."
                        ),
                        shiny::conditionalPanel(
                            condition = "input.git == true",
                            shinyFiles::shinyDirButton(
                                "root",
                                label = "Change git root",
                                title = "Please choose a folder"
                            ),
                            shiny::uiOutput("folder")
                        )
                    )
                )
            )
        )
    )

    server <- function(input, output, session) {

        shiny::observeEvent(input$add, {
            insertUI(
                selector = "#add",
                where = "beforeBegin",
                ui = shiny::textInput(
                    paste0("txt", input$add),
                    label = NULL,
                    placeholder = "ex. data/source"
                    )
            )
        })

        shiny::observeEvent(input$done, {
            returnValue <- ...
            stopApp(returnValue)
        })
    }

    viewer <- shiny::dialogViewer("cabinets: Project Specific Workspace Organization Templates", width = 600, height = 400)
    shiny::runGadget(ui, server, viewer = viewer)

}

