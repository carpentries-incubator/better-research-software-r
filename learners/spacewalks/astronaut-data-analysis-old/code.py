#https://data.nasa.gov/Raw-Data/Extra-vehicular-Activity-EVA-US-and-Russia/9kcy-zwvn/about_data

csvfile = open('/home/sarah/Projects/ssi-ukrn-fair-course/Extra-vehicular_Activity__EVA__-_US_and_Russia_20240126.csv', 'r')
jsonfile= open('file.json', 'a')
fieldnames = ("EVA #", "Country", "Crew    ", "Vehicle", "Date", "Duration", "Purpose")

for count in range(370):
    line = csvfile.readline().split(',')

    #dict
    l = dict()
    for thing in range(len(line[:7])):
        #print(thing)
        l[fieldnames[thing]] = line[thing]

    import json
    json.dump(l, jsonfile)
    jsonfile.write('\n')

jsonfile.close()

data=[]

for line in open('file.json', 'r'):
    data.append(json.loads(line))
data.pop(0)

import datetime as dt

time = []
date =[]

j=0
for i in data:
    print(data[j])
    if 'Duration' in data[j].keys():
        tt=data[j]['Duration']
        if tt == '':
            pass
        else:
            t=dt.datetime.strptime(tt,'%H:%M')
            ttt = dt.timedelta(hours=t.hour, minutes=t.minute, seconds=t.second).total_seconds()
            print(t,ttt)
            time.append(ttt)
            date.append(data[j]['Date'])
    j+=1

t=[0]
for i in time:
    t.append(t[-1]+i)

import matplotlib.pyplot as myplot

myplot.plot(date,t[1:])
myplot.show()
