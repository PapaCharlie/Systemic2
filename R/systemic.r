if (! exists('.systemic.loaded')) {


    .require.library <- function(name, hush = FALSE) {
        if (hush)
            req <- suppressMessages(require(name, warn.conflicts = F, character.only = TRUE, quietly = TRUE))
        else
            req <- require(name, warn.conflicts = F, character.only = TRUE, quietly = TRUE)
        
        if (! req && getOption("systemic.install.packages", FALSE)) {
            warning(paste("Installing package ", name, "\n"))	
            install.packages(name, repos="http://cran.us.r-project.org")
            options(systemic.installed = TRUE)
            require(name, character.only = TRUE)
        }
    }


    req <- suppressMessages(require('rdyncall', warn.conflicts = FALSE, character.only = TRUE, quietly = TRUE))
    if (! req) {
        if (Sys.info()["sysname"] == "Darwin") {
            install.packages('rdyncall_0.7.5.tgz', repos=NULL)
            require('rdyncall', character.only = TRUE)
        } else {
            error("Please install rdyncall. See the README for details.")
        }
    }
    
    
    .require.library('bitops')
    .require.library('gdata', hush=TRUE)
    .require.library('gplots', hush=TRUE)
    .require.library('circular', hush=TRUE)
    .require.library('compiler')
    .require.library('lattice')
    .require.library('MASS', hush=TRUE)
    .require.library('KernSmooth', hush=TRUE)
    .require.library('stringr', hush=TRUE)
    .require.library('Hmisc', hush=TRUE)
    .require.library('parallel', hush=TRUE)
    .require.library('xtable', hush=TRUE)
    
    if (exists('.systemic.env')) {
        tryCatch({
            detach('.systemic.env')
            detach('.systemic.functions')
        }, error=function(...) {})
    }

    .job <- ""
    .systemic.env <- new.env()
    sys.source("defs.r", .systemic.env)

    attach(.systemic.env)
    enableJIT(3)

    .systemic.functions <- new.env()
    sys.source("functions.r", .systemic.functions)
    sys.source("xgrid.r", .systemic.functions)
    sys.source("colors.r", .systemic.functions)
    sys.source("plots.r", .systemic.functions)
    # sys.source("genoud.r", .systemic.functions)
    sys.source("utils.r", .systemic.functions)
    sys.source("table.r", .systemic.functions)
    sys.source("phases.r", .systemic.functions)
    
    attach(.systemic.functions)
    .systemic.loaded <- TRUE
}
