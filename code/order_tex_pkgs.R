# order TeXLive.pkgs
con_tex <- file("latex/TeXLive.pkgs")
writeLines(sort(readLines(con_tex),decreasing = FALSE),con = con_tex)
close(con_tex)
