nbinstar <- function(graphs, ids, N=100, spacing='linear', lim=0) {
  require(emdbook)
  if (spacing != 'log' && spacing != 'linear') {
    stop(paste('Unknown spacing type:', spacing))
  }
  d <- dim(graphs)
  king <- 0
  if (lim) {
    set <- unique(round(lseq(2, lim, N)))
  } else {
    set <- 2:N
  }
  mnrs <- array(rep(NA, length(set)), length(set))
  print(set)
  for (i in set) {
    if (spacing=='log') {
      bs <- lseq(1/i, 1-1/i, i-1)
    } else {
      bs <- seq(1/i, 1-1/i, length.out=i-1)
    }
    tempg <- array(rep(0, d[1]*d[2]*d[3]), d)
    for (j in 1:length(bs)) {
      tempg <- tempg + (graphs > bs[j])
    }
    tempd <- distance(tempg, norm='F')
    mnrs[i] <- mnr(rdf(tempd, ids))
    print(mnrs[i])
    if (mnrs[i] > king) {
      king <- mnrs[i]
      kingbins <- bs
      kingdist <- tempd
      kingrdf <-rdf(tempd, ids)
    }
  }
  mnrs<-mnrs[which(!is.na(mnrs))]
  pack <- list(king, kingbins, kingdist, kingrdf, mnrs, set)
  return(pack)
}
