


`inla.update` = function(lib = NULL, testing = FALSE, ask = TRUE)
{
    inla.installer(lib=lib, testing=testing, ask = ask)
}

`inla.installer` = function(lib = NULL, testing = FALSE, ask = TRUE)
{
    repo=c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/",
        INLA = paste("https://inla.r-inla-download.org/R/",
            (if (testing) "testing" else "stable"),  sep=""))
    if (require("INLA", quietly = TRUE, lib.loc = lib,
                character.only=TRUE, warn.conflicts=FALSE)) {
        suppressWarnings(new.pack <- any(old.packages(repos = repo)[,1] == "INLA"))
        if (new.pack) {
            if (.Platform$OS.type == "windows") {
                cat(sep="",
                    "\n *** Windows locks the INLA-package's DLL when its loaded, see",
                    "\n ***     https://cran.r-project.org/bin/windows/base/rw-FAQ.html",
                    "\n *** Section 4.8,  so you cannot update a package that is in use.",
                    "\n *** We recommend to remove the INLA-package and then reinstall, like",
                    "\n     remove.packages(\"INLA\")")
                if (testing) {
                    cat("\n     install.packages(\"INLA\", repos=\"https://inla.r-inla-download.org/R/testing\")")
                } else {
                    cat("\n     install.packages(\"INLA\", repos=\"https://inla.r-inla-download.org/R/stable\")")
                }
                cat("\n *** and then restart R.", "\n")
            } else {
                suppressWarnings(update.packages(repos = repo, oldPkgs = "INLA", ask = ask))
                cat("\n *** If the INLA-package was updated, you need to restart R and load it again.\n\n")
            }
        } else {
            cat("\n *** You already have the latest version.\n\n")
        }
    } else {
        install.packages(pkgs = "INLA", lib = lib, repos = repo,
                         dependencies = TRUE)
        library("INLA")
    }

    return (invisible())
}


`inla.installer.os` = function(type = c("linux", "mac", "windows", "else"))
{
    if (missing(type)) {
        stop("Type of OS is required.")
    }
    type = match.arg(type)

    if (type == "windows") {
        return (.Platform$OS.type == "windows")
    } else if (type == "mac") {
        result = (file.info("/Library")$isdir && file.info("/Applications")$isdir)
        if (is.na(result)) {
            result = FALSE
        }
        if (result) {
            ## check that the version is at least the one use to build the binaries.
            s = system("sw_vers -productVersion", intern=T)
            vers = as.integer(strsplit(s, ".", fixed=TRUE)[[1]])
            ver = vers[1] + vers[2]/10
            s.req = 10.10 ## @@@HARDCODED@@@
            if (ver < s.req) {
                stop("Your version, ", s, ", of MacOSX is to old for R-INLA. Update MacOSX to at least version ",
                     as.character(s.req), sep="")
            }
        }
        return (result)
    } else if (type == "linux") {
        return ((.Platform$OS.type == "unix") && !inla.installer.os("mac"))
    } else if (type == "else") {
        return (TRUE)
    } else {
        stop("This shouldn't happen.")
    }
}
`inla.installer.os.type` = function()
{
    for (os in c("windows", "mac", "linux", "else")) {
        if (inla.installer.os(os)) {
            return (os)
        }
    }
    stop("This shouldn't happen.")
}

`inla.installer.os.32or64bit` = function()
{
    return (ifelse(.Machine$sizeof.pointer == 4, "32", "64"))
}
`inla.installer.os.is.32bit` = function()
{
    return (inla.installer.os.32or64bit() == "32")
}
`inla.installer.os.is.64bit` = function()
{
    return (inla.installer.os.32or64bit() == "64")
}

`givemeINLA` = function(...) inla.installer(...)
if (!exists("inla.lib")) inla.lib = NULL
givemeINLA(testing=FALSE, lib = inla.lib)
cat("\n\n\nYou can later upgrade INLA using: inla.upgrade()\n")
