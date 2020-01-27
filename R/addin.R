
cabinetsGadget <- function() {
    ui <- miniUI::miniPage(
        miniUI::gadgetTitleBar("Create a Cabinet"),
        miniUI::miniContentPanel(

        )
    )

    server <- function(input, output, session) {

        observeEvent(input$done, {
            returnValue <- ...
            stopApp(returnValue)
        })
    }

    runGadget(ui, server, viewer = dialogViewer("cabinetsGadget"))
}

projectGadget <- function() {

    ui <- miniUI::miniPage(
        miniUI::gadgetTitleBar("New Cabinet Project"),
        miniUI::miniContentPanel(

        )
    )

    server <- function(input, output, session) {

        observeEvent(input$done, {
            returnValue <- ...
            stopApp(returnValue)
        })
    }

    runGadget(ui, server, viewer = dialogViewer("projectGadget"))

}

