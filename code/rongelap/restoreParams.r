restoreParams = function (bugsResult, ragged = NULL, extraX = NULL) 
{
    thearray = bugsResult$sims.array
    parnames = dimnames(thearray)[[3]]
    vecPars = grep("\\[[[:digit:]]+\\]$", parnames, value = TRUE)
    matPars = grep("[[:digit:]+],[[:digit:]]+\\]$", parnames, 
        value = TRUE)
    scPars = parnames[!parnames %in% c(vecPars, matPars)]
    scPars = scPars[grep("^beta", scPars, invert = TRUE)]
    result = list()
    if (length(matPars)) {
        precisionIndex = grep("^T", matPars)
        precisions = matPars[precisionIndex]
        matPars = matPars[-precisionIndex]
        result$precision = thearray[, , precisions]
        precisions = unique(gsub("\\[[[:digit:]]+,[[:digit:]]+\\]", 
            "", precisions))
        for (D in precisions) {
            result[[paste("var", D, sep = "")]] = cholInvArray(result$precision, 
                D)
        }
        colno = substr(matPars, regexpr(",[[:digit:]]+\\]", matPars) + 
            1, 10000)
        colno = substr(colno, 1, nchar(colno) - 1)
        maxcol = max(as.integer(colno))
        if (is.na(maxcol)) 
            warning("can't find max col number")
        interceptcols = grep(paste(",", maxcol, "\\]", sep = ""), 
            matPars)
        slopecols = matPars[-interceptcols]
        result$slopes = thearray[, , slopecols]
        matPars = which(parnames %in% matPars)
        parnames[matPars] = gsub(paste(",", maxcol, "\\]", sep = ""), 
            "\\]", parnames[matPars])
        dimnames(thearray)[[3]] = parnames
        vecPars = grep("\\[[[:digit:]]+\\]$", parnames, value = TRUE)
    }
    thephi = grep("^phi", scPars, value = TRUE)
    for (D in thephi) {
        thesd = gsub("^phi", "SD", D)
        if (thesd %in% scPars) {
            scPars = grep(D, scPars, invert = TRUE, value = TRUE)
            therange = gsub("^phi", "range", D)
            result[[therange]] = thearray[, , D]/thearray[, , 
                thesd]
        }
    }
    for (D in scPars) result[[D]] = thearray[, , D]
    if (!length(scPars)) 
        warning("no parameter names")
    fixedEffects = grep("^X", names(ragged), value = TRUE)
    betas = NULL
    for (D in fixedEffects) {
        tobind = thearray[, , grep(gsub("^X", "beta", D), dimnames(thearray)[[3]]), 
            drop = F]
        if (!dim(tobind)[3]) 
            warning("can't find fixed effect parameters for ", 
                D)
        newnames = dimnames(ragged[[D]])[[2]]
        if (length(newnames) == (dim(tobind)[3])) 
            dimnames(tobind)[[3]] = newnames
        betas = abind::abind(betas, tobind, along = 3)
    }
    result$betas = betas
    groups = unique(gsub("\\[[[:digit:]]+\\]$", "", vecPars))
    thebetas = grep("^beta", groups)
    if (length(thebetas)) 
        groups = groups[-thebetas]
    for (D in groups) {
        thisGroup = grep(paste("^", D, "\\[", sep = ""), vecPars, 
            value = TRUE)
        result[[D]] = thearray[, , thisGroup]
    }
    theSpatialGroups = grep("Spatial$", groups)
    if (length(theSpatialGroups)) {
        notSpatial = groups[-theSpatialGroups]
    }
    else {
        notSpatial = groups
    }
    for (D in notSpatial) {
        result[[paste("Fitted", D, sep = "")]] = result[[D]]
    }
    if (is.null(ragged)) {
        return(result)
    }
    groups = paste("S", substr(groups, 2, nchar(groups)), sep = "")
    randomEffects = groups[groups %in% names(ragged)]
    randomEffects = names(sort(unlist(lapply(ragged[randomEffects], 
        length))))
    randomEffects = substr(randomEffects, 2, nchar(randomEffects))
    if (!length(randomEffects)) {
        warning(paste(toString(groups), ":cannot find random effects"))
        return(result)
    }
    theMeanOld = array(result[["intercept"]], c(dim(result[["intercept"]]), 
        1))
    Nchain = dim(theMeanOld)[2]
    torep = rep(1, length(ragged[[paste("S", randomEffects[1], 
        sep = "")]]) - 1)
    betanames = dimnames(result$betas)[[3]]
    for (D in randomEffects) {
        theR = paste("R", D, sep = "")
        theS = ragged[[paste("S", D, sep = "")]]
        thenames = names(theS)[-length(theS)]
        if (length(thenames) != (dim(result[[theR]])[3])) 
            warning(D, "different dimensions in bugsResult and ragged")
        dimnames(result[[theR]])[[3]] = thenames
        dimnames(result[[paste("Fitted", theR, sep = "")]])[[3]] = thenames
        DX = paste("X", D, sep = "")
        Dbeta = paste("beta", D, sep = "")
        themean = theMeanOld[, , torep]
        if (!is.null(ragged[[DX]])) {
            theX = t(ragged[[DX]])
            if (Dbeta %in% betanames) {
                theseBetas = result$betas[, , Dbeta, drop = F]
            }
            else {
                if (all(rownames(theX) %in% dimnames(result$betas)[[3]])) {
                  theseBetas = result$betas[, , rownames(theX), 
                    drop = FALSE]
                }
                else {
                  warning("cannot find ", D, " , ", DX)
                }
            }
            for (Dchain in 1:Nchain) {
                themean[, Dchain, ] = themean[, Dchain, ] + abind::adrop(theseBetas[, 
                  Dchain, , drop = FALSE], drop = 2) %*% theX
            }
        }
        theMeanOld = result[[theR]]
        torep = diff(theS)
        torep = rep(1:length(torep), torep)
        result[[theR]] = result[[theR]] - themean
    }
    spatialEffects = paste("R", randomEffects, "Spatial", sep = "")
    spatialEffects = spatialEffects[spatialEffects %in% names(result)]
    for (D in spatialEffects) {
        DsubR = gsub("Spatial$", "", D)
        Dsub = gsub("^R", "", DsubR)
        Dfitted = paste("Fitted", DsubR, sep = "")
        thenames = names(ragged[[paste("num", Dsub, sep = "")]])
        if (is.null(thenames)) {
            thenames = paste("noname", 1:ragged[[paste("N", Dsub, 
                "Spatial", sep = "")]], sep = "")
            thenames[ragged[[paste("Sspatial", Dsub, sep = "")]]] = names(ragged[[paste("Sspatial", 
                Dsub, sep = "")]])
        }
        theID = dimnames(result[[D]])[[3]]
        theID = gsub("[[:graph:]]+\\[", "", theID)
        theID = gsub("\\]$", "", theID)
        dimnames(result[[D]])[[3]] = thenames[as.integer(theID)]
        regionsNoV = thenames[!thenames %in% dimnames(result[[DsubR]])[[3]]]
        if (length(regionsNoV)) {
            dimNoV = c(dim(result$intercept), length(regionsNoV))
            sdBig = array(result[[paste("SD", Dsub, sep = "")]], 
                dimNoV)
            VfornoV = stats::rnorm(prod(dim(sdBig)), 0, sdBig)
            VfornoV = array(VfornoV, dimNoV)
            dimnames(VfornoV)[[3]] = regionsNoV
            DsubSpatial = paste(DsubR, "Spatial", sep = "")
            withSpatial = regionsNoV[regionsNoV %in% dimnames(result[[DsubSpatial]])[[3]]]
            VfornoV[, , withSpatial] = VfornoV[, , withSpatial] + 
                result[[DsubSpatial]][, , withSpatial]
            result[[DsubR]] = abind::abind(result[[DsubR]], VfornoV, 
                along = 3)
            fittedForNoV = VfornoV + array(result$intercept, 
                dimNoV)
            if (!is.null(extraX)) {
                haveExtraX = rownames(extraX)[rownames(extraX) %in% 
                  VfornoV]
                theBeta = result[[paste("beta", Dsub, sep = "")]]
                haveBeta = colnames(extraX)[colnames(extraX) %in% 
                  rownames(theBeta)]
                if (length(haveExtraX) & length(haveBeta)) {
                  fittedForNoV = fittedForNoV + extraX[haveExtraX, 
                    haveBeta] %*% theBeta[haveBeta, ]
                }
            }
            result[[Dfitted]] = abind::abind(result[[Dfitted]], 
                fittedForNoV, along = 3)
            result[[DsubR]] = result[[DsubR]][, , thenames]
            result[[Dfitted]] = result[[Dfitted]][, , thenames]
        }
    }
    #if (dim(result$betas)[3] == 1) {
    #    result$betas = result$betas[, , 1]
    #}
    return(result)
}
