dat <- read.table(file="data/NOTREDAM.TXT",header=T)

with(dat,{
plot(North.South~East.West,frame.plot = F,pch =16)
text(x = East.West, y = North.South, 
     labels = Elevation, adj = c(0,0), xpd = 1) 
})
