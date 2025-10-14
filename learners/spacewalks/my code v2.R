# https://data.nasa.gov/resource/eva.json (with modifications)
data_f_file = '/home/sarah/Projects/astronaut-analysis/data.json'
data_t_file = '/home/sarah/Projects/astronaut-analysis/data.csv'
g_file = 'myPlot.png'
fieldnames <- c("EVA #", "Country", "Crew    ", "Vehicle", "Date", "Duration", "Purpose")

library(jsonlite)

j_l <- read_json(data_f_file)
data=as.data.frame(j_l[[1]])

for( i in 2:374){
  r = j_l[[i]]
    print(r)
    data =merge(data, as.data.frame(r),  all=TRUE)
}
#data.pop(0)
## Comment out this bit if you don't want the spreadsheet
write.csv(data_t_file)



time <- c()
date = Date()

library(lubridate)
j=1
for (i in rownames(data)){
    print(data[j, ])
    # and this bit
    # w.writerow(data[j].values())
    if (!is.na(data[j,]$duration)){
        tt=data[j,]$duration
        if(tt == ''){
          #do nothing
        }else{
            t=as.POSIXlt(tt,format='%H:%M')
            ttt <- as.numeric(as.difftime(hour(t), units = 'hours')+as.difftime(minute(t), units='mins')+as.difftime(second(t), units='secs'))/(60*60)
            print(t,ttt)
            time <- c(time, ttt)
            if(!is.na(data[j,]$date)){
                date= c(date, as.Date(substr(data[j,'date'], 1, 10), format = '%Y-%m-%d'))
                #date.append(data[j]['date'][0:10])

            }else{
              time <- time[1:length(time) -1]
                }
            }
        }
    j = j+1
}

t=0
for(i in time)
    t <- c(t, t[length(t)]+i)


df <- data.frame(
date, time
)[order(date, time), ]

date <- df$date
time <- df$time


png(g_file)
plot(date,t[2:length(t)],
xlab = 'Year', ylab= 'Total time spent in space to date (hours)'
)
dev.off()
plot(date,t[2:length(t)],
xlab = 'Year', ylab= 'Total time spent in space to date (hours)'
)
