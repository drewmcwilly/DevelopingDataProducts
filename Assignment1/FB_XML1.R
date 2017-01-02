    require(XML)
    library(plyr)
    library(dplyr)
    library(stringr)
    library(ggmap)
    library(leaflet)
    library(plotly)
    library(tidyr)
    setwd("~/Coursera/Developing Data Products/FirstApp/DevelopingDataProducts/Assignment1")
    source('time_match.R')
    xml_file<-choose.files()
    
    xml_File<-xmlInternalTreeParse(xml_file)
    
#pull data in from tcx fil
    data<-xmlParse(xml_file)
#put into a list
    xml_data<-xmlToList(data)
#Filter the XML list down to get to the workout data
    temps <- xml_data[["Activities"]][["Activity"]][["Lap"]][["Track"]]
#Transfer content into a data frame
    df2<-ldply(temps, data.frame)
      
    colnames(df2)<-c("Label","Time","Latitude","Longitude","Meters_Altitude","Meters_Distance")
 
# Convert columns to numeric    
    df2$Meters_Distance<- as.numeric(as.character(df2$Meters_Distance))
    df2$Meters_Altitude<- as.double(as.character(df2$Meters_Altitude))
    df2$Time<- str_replace_all(str_replace_all(str_replace_all(as.character(df2$Time), "T", " "),"\n",""),"\t","")
    df2$Time<- as.POSIXct(substr(df2$Time, 1,19), format="%Y-%m-%d %H:%M:%S")
    df2$Latitude<- as.numeric(as.character(df2$Latitude))
    df2$Longitude<- as.numeric(as.character(df2$Longitude))
#append extra columns
    df2<-mutate(df2, Meters_Interval=Meters_Distance- lag(Meters_Distance, default=0))
    df2<-mutate(df2, Miles=floor(1+(Meters_Distance/1609.344)))
    df2<-mutate(df2, Elapsed_Distance=Meters_Distance/1609.344)
    df2<-mutate(df2,DateTime=as.POSIXct(Time))
    df2<-mutate(df2,Elapsed_Time=(DateTime-DateTime[1])/60)
    df2<-mutate(df2, RunSpeed_MPH=(Meters_Interval*3600)/1609.344)
    df2<-mutate(df2, speed_delta=RunSpeed_MPH-lag(RunSpeed_MPH, default=0))
    df2$min<-format(df2$DateTime, "%H:%M")
    df2$Feet_Altitude<-df2$Meters_Altitude*3.28084
    df2$Speed_color <- ifelse(df2$RunSpeed_MPH >=lag(df2$RunSpeed_MPH), "Green", "Yellow")
    df2$Speed_color[which(is.na(df2$Speed_color))]<-"Blue"
##Assemble Runmap
    
    
 
   ## interactive_map(mean(df2$Latitude), mean(df2$Longitude))

   center<-as.array(c(mean(df2$Longitude), mean(df2$Latitude)))

##Weather data here:
    res <- revgeocode(center, output="more")
    zCode<-res$postal_code
    wd<-format(df2[1,"DateTime"],"%Y%/%m%/%d")
    w_url<-paste("https://www.wunderground.com/history/airport/KXLL/",wd,"/DailyHistory.html?reqdb.zip=",zCode,"&reqdb.magic=1&reqdb.wmo=99999&format=1", sep="")
    weather<-read.csv(url(w_url))
##Clean up weather data
    weather$DateUTC.br...<-as.character(weather$DateUTC.br...)
    colnames(weather)<-c("TimEDT","TemperatureF","Dew.PointF","Humidity","Sea.Level.PressureIn","VisibilityMPH","Wind.Direction","Wind.SpeedMPH","Gust.SpeedMPH","PrecipitationIn","Events","Conditions","WindDirDegrees","DateUTC")
    weather$DateUTC<-gsub("<br />","",weather$DateUTC)
    weather$DateUTC<-as.POSIXlt(weather$DateUTC)
    weather$DateEST<-weather$DateUTC
    weather$DateEST$hour<-weather$DateEST$hour-4
    
##merge weather with Run data
    df2$index<-sapply(df2$DateTime,Match_Time)
    df2$TemperatureF<-weather[df2$index,2]
    df2$Dew.PointF<-weather[df2$index,3]
    df2$Humidity<-weather[df2$index,4]
    df2$Sea.Level.PressureIn<-weather[df2$index,5]
    df2$VisibilityMPH<-weather[df2$index,6]
    df2$Wind.Direction<-weather[df2$index,7]
    df2$Wind.SpeedMPH<-weather[df2$index,8]
    df2$Gust.SpeedMPH<-weather[df2$index,9]
    df2$PrecipitationIn<-weather[df2$index,10]
    df2$Events<-weather[df2$index,11]
    df2$Conditions<-weather[df2$index,12]
    df2$WindDirDegrees<-weather[df2$index,13]
    
    
    
    avg_Grp<-as.data.frame(df2%>% group_by(min)%>% 
                               summarize(avg_Speed=mean(RunSpeed_MPH), avg_temp=mean(TemperatureF), avg_alt=mean(Feet_Altitude),avg_humid=mean(Humidity)))
    def_temp<-avg_Grp[1,"avg_temp"]
    def_alt<-avg_Grp[1,"avg_alt"]
    def_hum<-avg_Grp[1,"avg_humid"]
    avg_Grp<-avg_Grp%>% mutate(Temp_change=avg_temp-lag(avg_temp, default=def_temp))%>%
        mutate(Alt_change=avg_alt-lag(avg_alt, default=def_alt))%>%
        mutate(Humid_change=avg_humid-lag(avg_humid, default=def_hum))
    plot_Df<-avg_Grp[,c(1,2,6,7,8)]
    plot_Df<-gather(plot_Df, measurement, value, 2:5)
    plot_ly(plot_Df, x = plot_Df$min, y = plot_Df$value,  color = plot_Df$measurement)
    
    
 ##   avg_grp<-df2%>%group_by( Miles ) %>%summarize(avgspd=mean(RunSpeed_MPH))
 ##   plot_ly(avg_grp, x = avg_grp$Miles, y = avg_grp$avgspd, mode = "lines")
    
    interactive_map(mean(df2$Latitude), mean(df2$Longitude))
    