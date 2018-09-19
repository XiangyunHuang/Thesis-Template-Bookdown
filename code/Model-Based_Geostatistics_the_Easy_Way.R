#' install packages

#+ packages
if(FALSE) { 
install.packages("geostatsp")
install.packages("diseasemapping")
install.packages("mapmisc")
install.packages("xtable")

install.packages("pixmap")
install.packages("numDeriv")
source("http://www.math.ntnu.no/inla/givemeINLA.R")
}
#'

#+ loadPackages
library("geostatsp")	
library("mapmisc")
library('RColorBrewer')
library("rgdal")
library("diseasemapping")
#'

#' Swiss Rain Example

#' data and tiles

#+ swissData
data("swissRain")
#'

#+ swissTiles, cache=TRUE
swissTiles = openmap(swissBorder)
#'

#' plot the data
#+ swissRain,fig.height=4,fig.width=6, fig.cap='Map of Switzerland with rainfall values'

rainCol = colourScale(swissRain$rain, col="Blues", dec=-1,
		breaks=6,style='quantile')

map.new(swissBorder)
plot(swissAltitude, col=terrain.colors(8),
		legend.args=list(text="elevation(m)"), add=TRUE)
plot(swissBorder, add=TRUE, border='#FF000080',lwd=3)
points(swissRain, col=rainCol$plot,pch=16)

legendBreaks('topleft', breaks=rainCol,title="rain(mm)",bg="white")
#'


#' Fit the model

#+ swissFit, cache=TRUE
names(swissRain)
names(swissAltitude)
swissFit = lgm( rain~ CHE_alt,swissRain,
		grid=80, covariates=swissAltitude,
		shape=1,  fixShape=TRUE, 
		boxcox=0.5, fixBoxcox=TRUE, 
		aniso=TRUE)
names(swissFit)

swissFit$param
#'

#' plot predicted values
#+ swissPlotPred,fig.height=4,fig.width=6, fig.cap='fitted values'
plotRaster = raster::mask(swissFit$predict[["predict"]], swissBorder)


map.new(swissBorder)
plot(swissTiles, add=TRUE)
plot(plotRaster, alpha=0.8,add=TRUE, col=brewer.pal(8,"Greens"),
		legend.args=list(text='',side=1, line=0.5, cex=0.8),
		legend=FALSE)
plot(swissBorder,add=TRUE,border="grey",lwd=2)

plot(plotRaster,add=TRUE, col=brewer.pal(8,"Greens"),
		legend.only=TRUE, legend.mar=3.5, axis.args=list( ),
		legend.args=list(text="rain(mm)",adj=0,line=0.7))
#'

#'exceedance probabilities

#+ swissPlotExc,fig.height=4,fig.width=6, fig.cap='exceedance probabilities'
exc30 = excProb(swissFit, 30)
plotRasterE = raster::mask(exc30, swissBorder)

mycol = rev(brewer.pal(4,"RdYlGn"))
mybreaks = c(0, 0.2, 0.8, 0.95, 1)

map.new(swissBorder)
plot(swissTiles, add=TRUE)
plot(plotRasterE, alpha=0.5,add=TRUE, 
		col=mycol,
		breaks = mybreaks, legend=FALSE)
plot(swissBorder,add=TRUE,border="grey",lwd=2)


legend("bottomright", pch=15, pt.cex=2.5, col=c(rev(mycol), NA), legend=rev(mybreaks),
		adj=c(0,-0.5))
#'


#' loaloa 

#+ loaloaData, cache=TRUE
data("loaloa")
africaTiles = openmap(loaloa)
if(!file.exists("world.zip"))
	download.file(
		"http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries_lakes.zip", 
		'world.zip')
unzip('world.zip')
theFiles = unzip('world.zip', list=TRUE)
theFiles = grep("\\.shp$", theFiles$Name, value=TRUE)


worldCountries = readOGR(".", gsub("\\.shp$", "", theFiles),
		verbose=FALSE)
worldCountries = worldCountries[worldCountries$CONTINENT=='Africa',]
worldUTM = spTransform(worldCountries, loaloa@proj4string)
#'

#' plot data

#+ loaloaPlot,fig.height=4,fig.width=10
map.new(loaloa,0.6)
plot(africaTiles,add=TRUE)
plot(ltLoa,add=TRUE)
points(loaloa, pch=3, col='#FF0000CC', cex=1.75)
plot(worldUTM, add=TRUE, border="grey",lwd=2)
theLegend = levels(ltLoa)[[1]]

theLegend = theLegend[theLegend$ID!= 0,]
commonValues  = order(theLegend$n,decreasing=TRUE)[1:7]
 
legend("right", fill=theLegend[commonValues,"col"], 
		legend=
				substr(theLegend[,"Category"],1,28),
		inset=-0.6,xpd=T)
#'

#' Elevation with a change point

#+ loaElev, echo=TRUE 
elevationLoa = elevationLoa - 750
elevLow = reclassify(elevationLoa, c(0, Inf, 0))
elevHigh = reclassify(elevationLoa, c(-Inf, 0, 0))
#'

#' Land types with a very small number of observations are merged with more
#' populated land types, with

#+ ltReclassify,echo=TRUE
rcl = rbind(c(9,8),# savannas to woody savannas
	c(5,2),c(11,2),	# wetlands and mixed forests to forest
	# croplands and urban to crop/natural mosaic
	c(12,14),c(13,14))
ltLoaRe = reclassify(ltLoa, rcl)
levels(ltLoaRe) = levels(ltLoa)
#'

#' List of rasters
#+ covListLoa, echo=TRUE
covList = list(elLow = elevLow, elHigh = elevHigh, 
		land = ltLoaRe, evi=eviLoa)
#'

#'  fit the model

#+ loaFit, cache=TRUE
loaFit = glgm(formula=y ~ land + evi + elHigh + elLow,
		data=loaloa,grid=50,		
		covariates=covList,
		family="binomial", Ntrials = loaloa$N, 
	 shape=1, buffer=50000,
		priorCI = list(sd=c(0.2, 4), range=c(20000,500000)))
rownames(loaFit$parameters$summary) = substr(rownames(loaFit$parameters$summary), 1, 25)
loaFit$parameters$summary[,c(1 ,3,5)]
#'

#' plot fitted probabilities

#+ loaPlotProb,fig.height=4,fig.width=6
thebreaks = seq(0, 0.6, by=0.15 )
thecol = brewer.pal(length(thebreaks)-1, "YlOrRd")
map.new(loaloa)
plot(africaTiles,add=TRUE)
plot(loaFit$raster[["predict.invlogit"]],col=thecol,
		breaks = thebreaks,add=TRUE, alpha=0.7, legend=FALSE)

plot(worldUTM, add=TRUE, border="grey",lwd=2)
legendBreaks("topleft", col=thecol,breaks=thebreaks)
#'

#'  spatial random effects

#+ loaPlotRE,fig.height=4,fig.width=6
thebreaks = colourScale(loaFit$raster[["random.mean"]],
		style='equal', dec=1, breaks=6, col='YlOrRd')

map.new(loaloa)
plot(africaTiles,add=TRUE)
plot(loaFit$raster[["random.mean"]],col=thebreaks$col, breaks=thebreaks$breaks,
		add=TRUE, alpha=0.7, legend=FALSE)
plot(worldUTM, add=TRUE, border="grey",lwd=2)
legendBreaks("topleft", breaks=thebreaks)
#+

#' posterior distributions

#+plotPost,fig.height=4,fig.width=8
par(mfrow=c(1,2))
x=loaFit$param$range
plot(x$posterior,type="l",xlab="range (km)",ylab="dens",xlim=c(1000,100000), xaxt='n')
axis(1, at=seq(0, 100000,by=20000), label=seq(0, 100, by=20))
lines(x$prior,col="blue")
legend("topright", lty=1, col=c('black','blue'), legend=c("post'r", 'prior'))

x=loaFit$param$sd
plot(x$posterior,type="l",xlab=expression(sigma),ylab="dens",xlim=c(0.25,1.5))

lines(x$prior,col="blue")
legend("topright", lty=1, col=c('black','blue'), legend=c("post'r", 'prior'))
#'

#' Toronto murders 



#+ murderData, echo=TRUE, cache=TRUE
data("murder")
data("torontoPop")
murder= murder[murder$year > 1999,]
#'

#' remove duplicates
#+ murderDuplicates, echo=TRUE
murder = murder[!duplicated(coordinates(murder)[,1]),]
#'

#+ murderTiles, echo=TRUE, cache=TRUE
torTiles = openmap(torontoIncome)
#'

#' plot data

#+ murderPlot,fig.height=4,fig.width=6
thecol=brewer.pal(5, "YlOrRd")
thebreaks = signif(
		exp(seq(log(18000), log(500000),len=length(thecol)+1)),
		1)
map.new(torontoBorder)
plot(torTiles,add=TRUE)
plot(torontoIncome, col=thecol,
		breaks = thebreaks,legend=FALSE,add=TRUE,alpha=0.5
)
plot(torontoBorder, border='grey',lwd=2,add=TRUE)
points(murder, cex=.8, col='#00000050')
legend("bottomright", pch=15,pt.cex=2,col=c(NA,rev(thecol)), 
		legend=rev(thebreaks/1000),title="$ '000", adj=c(0,1))
#'


#' list of covariates

#+ covariatesMurder
covList = list(loginc = log(torontoIncome),
		logpop = log(torontoPdens), light=torontoNight^2)
#'

#' mask a covariate so lgcp knows the study area 
#' is defined by torontoBorder 

#+ logInc
covList$loginc = raster::mask(covList$loginc, torontoBorder)
#'

#' fit the model
#' make grid a larger value (100 or 150) for sensible answers.  
#' and make the lower bound for the prior for range a smaller value
#' 50 and 500 are used below to allow the code to run quickly

#+ murderFit, cache=TRUE
murderFit = lgcp(formula=~ loginc + logpop + light,
		data=murder, 
		covariates=covList, grid=50,shape=2, buffer=1000,
		priorCI = list(range=c(500,5000),sd=c(0.1, 4)),
		border=torontoBorder)
#'

#+ murderResults
murderFit$par$summary[,c(1,3,5)]
#'

#' plot risk

#+ riskPlot,fig.height=4,fig.width=6, fig.cap='risk, posterior mean'

toplot = raster::mask(murderFit$raster, torontoBorder)

map.new(torontoBorder)
plot(torTiles,add=TRUE)
plot(10^6*toplot[["predict.exp"]],col=brewer.pal(7, "YlOrRd"),
		add=TRUE, alpha=0.6)
plot(torontoBorder, add=TRUE, border="grey",lwd=2)
#'

#' plot random effect

#+ ranEfPlot,fig.height=4,fig.width=6, fig.cap='U, posterior mean'
map.new(torontoBorder)
plot(torTiles,add=TRUE)
plot(toplot[["random.mean"]],col=brewer.pal(7, "YlOrRd"),
		add=TRUE, alpha=0.6)
plot(torontoBorder, add=TRUE, border="grey",lwd=2)
#'

#' kentucky cancer data 

#+ kdata
library("diseasemapping")
data("kentucky")
#'

#+ krates, cache=TRUE
larynxRates= cancerRates("USA", year=1998:2002,site="Larynx")
kentucky = getSMR(kentucky, larynxRates, larynx, 
		regionCode="County")
kentuckyTiles = openmap(kentucky)
#'
			
#'  plot counts			

#+ kplot,fig.height=5,fig.width=8,fig.cap='observed'	
map.new(kentucky)
plot(kentuckyTiles,add=TRUE)

countcol = colourScale(kentucky$observed, breaks=
				c(0, 1, 2, 5,10,40), col="YlOrRd",
		opacity=c(0.1, 1),style='fixed')

plot(kentucky, col=countcol$plot, add=TRUE, border='#00000050' )

legendBreaks('topleft',countcol)
#'

#' plot expected

#+ expectedPlot,fig.height=5,fig.width=8,fig.cap='expected'	
expcol = colourScale(kentucky$expected, breaks=
				countcol$breaks, col="YlOrRd",
		opacity=c(0.1, 1),style='fixed')

map.new(kentucky)
plot(kentuckyTiles,add=TRUE)

plot(kentucky, col=expcol$plot, add=TRUE,  border='#00000050' )
#'

#' fit the model

#+ kmodel
kBYM = bym(formula= observed ~ offset(logExpected) + poverty, 		
	data=kentucky,
		priorCI = list(sdSpatial=c(0.1, 5), sdIndep=c(0.1, 5)))
kBYM$par$summary[,c(1,3,5)]
#'

#' plot risk

#+ kPlotRes,fig.height=5,fig.width=8,fig.cap='lambda, posterior mean'	
map.new(kBYM$data)
plot(kentuckyTiles,add=TRUE)

theCol = colourScale(kBYM$data$fitted.exp, breaks=6, dec=1,opacity=c(0.5, 1))

plot(kBYM$data, col=theCol$plot, add=TRUE, border='#00000050' )

#'

#' plot exceedance probabilities

#+ excProbPlotK, fig.height=5, fig.width=8, fig.cap='exceedance' 
kBYM$data$excProb = excProb(kBYM$inla$marginals.fitted.bym, log(1.3))
coloursExc <- c("#00FF0050","#FFFF0010","#FF660080","#FF0000CC")
breaksExc = c(0, 0.2, 0.8, 0.95, 1)

colFac=coloursExc[cut(kBYM$data$excProb,breaksExc,include.lowest=TRUE)]


map.new(kBYM$data)
plot(kentuckyTiles,add=TRUE)
plot(kBYM$data, col=colFac, add=TRUE, border='#00000050' )
legend("topleft", pch=15, pt.cex=2.5,col=c(NA,rev(substr(coloursExc, 1, 7))), 
		legend= rev(breaksExc),bg="white",		adj=c(0,1))
#'

#' Simulation Study 

#+ covariates
covariates = brick(
		xmn=0,ymn=0,xmx=10,ymx=10,
		ncols=200,nrows=200,nl=2)
values(covariates)[,1] = rep(seq(0,1,len=nrow(covariates)), ncol(covariates))
values(covariates)[,2] = rep(seq(0,1,len=nrow(covariates)), 
		rep(nrow(covariates), ncol(covariates)))
names(covariates) = c("cov1","cov2")
#'

#+ model,tidy=TRUE,tidy.opts=list(width.cutoff=55)
myModel = c(intercept=0.5,variance=2^2,nugget=0.5^2, range=2.5,shape=2, 
		cov1=0.2, cov2=-0.5)
library("abind")
Npoints = 50
Nsim=4
oneSim = function(D){
	set.seed(D)
	myPoints = SpatialPoints(cbind(runif(Npoints,0,10), 
					runif(Npoints,0,10)))	
	myPoints = SpatialPointsDataFrame(myPoints, 
			as.data.frame(extract(covariates, myPoints)))
	myPoints$fixed = myModel["intercept"] +
			drop(
					as.matrix(myPoints@data)[,names(covariates)] %*%
							myModel[names(covariates)] 
			) 
	
	myPoints$U = RFsimulate(myPoints, model=myModel)$sim1 
	myPoints$y=  myPoints$fixed + myPoints$U+
			rnorm(length(myPoints), 0, sqrt(myModel["nugget"]))
	
	
	fitMLE =  lgm(y~ cov1 + cov2,
			myPoints, grid=10,  
			covariates=covariates, 
			shape=1, fixShape=TRUE)
	
	
	fitBayes = glgm(y~cov1 + cov2,
			myPoints, grid=30, 
			covariates=covariates, 
			buffer=3,
			priorCI = list(range=c(0.15, 10), sd=c(0.1, 10)))
	
	as.matrix(
			cbind(fitMLE$summary[
							c('(Intercept)','cov1','cov2','range','sdNugget','sdSpatial'),
							c('estimate','ci0.025','ci0.975')				
					], 
					fitBayes$par$summary[
							c('(Intercept)','cov1','cov2','range','sdNugget','sd'),
							c('mean','0.025quant','0.975quant')				
					])
	)
}
#'

#' run the simulations
#+ doSim, cache=TRUE
allResList=parallel::mcmapply(oneSim, 1:Nsim,mc.cores=4,SIMPLIFY=FALSE)
allRes = simplify2array(allResList)
#'

#' covariate 1

#+ simPlotCov,fig.height=4,fig.width=8,tidy=TRUE,tidy.opts=list(width.cutoff=55), fig.cap='covariate'
Sseq = 1:dim(allRes)[3]

matplot(Sseq, 
		t(allRes["cov1",c("mean","0.025quant","0.975quant",
								'estimate','ci0.025','ci0.975'),]),
		type='l', lty=c(1,2,2, 1, 2, 2), col=rep(c('blue','orange'),c(3,3)),
		xlab='simulation',ylab='beta 1'
)

abline(h=0.2)	
#'

#+ simPlotRange,fig.height=4,fig.width=8,tidy=TRUE,tidy.opts=list(width.cutoff=55), fig.cap='range parameter'

matplot(Sseq, 
		t(allRes["range",c("mean","0.025quant","0.975quant",
								'estimate','ci0.025','ci0.975'),]),
		type='l', lty=c(1,2,2, 1, 0, 0), col=rep(c('blue','orange'),c(3,3)),
		xlab='simulation',ylab='range', 
		ylim=c(0, 3*myModel["range"])
)
abline(h=myModel['range'] )
#'


