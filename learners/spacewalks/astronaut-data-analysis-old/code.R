#https://data.nasa.gov/Raw-Data/Extra-vehicular-Activity-EVA-US-and-Russia/9kcy-zwvn/about_data

csvfile = '/home/sarah/Projects/ssi-ukrn-fair-course/Extra-vehicular_Activity__EVA__-_US_and_Russia_20240126.csv'
jsonfile= 'file.json'
fieldnames = c("EVA #", "Country", "Crew    ", "Vehicle", "Date", "Duration", "Purpose")

df <- read.csv(csvfile)


cat('', file = jsonfile)
for (count in 1:370){
    line = df[count,]

    #list
    l = list()
    for (thing in 1:(ncol(line[,1:7])))
        #print(thing)
        l[[fieldnames[[thing]]]] = line[[thing]]

    library(jsonlite)
    cat(toJSON(l), file = jsonfile, append = TRUE)
    cat('\n', file = jsonfile, append = TRUE)
}


data=list()

for (line in readLines('file.json')){
    data <- c(data, list(fromJSON(line)))
}

# this was needed at one point, not now I think
#data[[1]] <- NULL

time <- c()
date = character(0)

library(lubridate)
j=1
for (i in data){
    print(data[[j]])
    # and this bit
    # w.writerow(data[j].values())
    if (!is.na(data[[j]]$Duration)){
        tt=data[[j]]$Duration
        if(tt == ''){
          #do nothing
        }else{
            t=as.POSIXlt(tt,format='%H:%M')
            ttt <- as.numeric(as.difftime(hour(t), units = 'hours')+as.difftime(minute(t), units='mins')+as.difftime(second(t), units='secs'))/(60*60)
            print(t,ttt)
            time <- c(time, ttt)
            date <- c(date, data[[j]][["Date"]])
        }
    
}
    j = j+1}

length(date)


t=0
for(i in time)
    t <- c(t, t[length(t)]+i)

as.numeric(date)


to_plot <- t[2:length(t)]
names(to_plot) <- date

barplot(to_plot)
