local({
  options(
    repos = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/", 
    bitmapType = "cairo",
    citation.bibtex.max = 999
  )
  # Sys.getenv('RSTUDIO_PANDOC') 
  # Ugly hacker for Pandoc on MY CentOS
  if(file.exists('/etc/centos-release')){
    Sys.setenv(CENTOS_PANDOC = "/home/xiangyun/.local/bin") # why $HOME/.local/bin does not work here
    if (Sys.which('pandoc') == '') Sys.setenv(PATH = paste(
      Sys.getenv('PATH'), Sys.getenv('CENTOS_PANDOC'), 
      sep = if (.Platform$OS.type == 'unix') ':' else ';'
    ))    
  }
})
