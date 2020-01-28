
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
                icon = shiny::icon("archive")
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
                        shiny::conditionalPanel(
                            condition = "input.git == true",
                            shinyFiles::shinyDirButton(
                                "root",
                                label = "Change git root",
                                title = "Please choose a folder",
                                class = "btn-primary"
                            ),
                            shiny::uiOutput("folder"),
                            shiny::br(),
                            shiny::helpText("The default directory for the git repository is is the root directory of the project. The following files are automatically added to .gitignore: .Rproj.user", ".Rhistory", ".Rdata", ".Ruserdata")
                        )
                    )
                )
            )
        )
    )

    server <- function(input, output, session) {

        shiny::observeEvent(input$done, {
            returnValue <- ...
            stopApp(returnValue)
        })
    }

    viewer <- shiny::dialogViewer("Create cabinets and start projects", width = 600, height = 400)
    shiny::runGadget(ui, server, viewer = viewer)

}

