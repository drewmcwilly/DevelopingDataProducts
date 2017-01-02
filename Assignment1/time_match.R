Match_Time<-function(x){
    y<-which.min(abs(difftime (x,weather$DateEST, units="mins")))
                
    y
}

 interactive_map<-function(lat,long){
     m <- leaflet(df2) %>%  addTiles()
     m<- m %>% addPolylines(df2$Longitude, df2$Latitude,color="Blue", stroke = TRUE, opacity = 0.5) 
     m<- m %>% addMarkers(lng=df2[1,"Longitude"], lat=df2[1,"Latitude"], popup="Start")
     m<- m %>% addMarkers(lng=df2[nrow(df2),"Longitude"], lat=df2[nrow(df2),"Latitude"], popup=paste("Finish:",round((df2[nrow(df2),"Meters_Distance"])*0.000621371,2),"Miles"))
     m<- m %>% addCircleMarkers(lng=df2[which.max(df2$Meters_Altitude),"Longitude"],lat=df2[which.max(df2$Meters_Altitude),"Latitude"], popup=paste("Highest Altitude: ", round(df2[which.max(df2$Meters_Altitude),"Feet_Altitude"],2), " Feet" ), fillColor="Red", weight=1, opacity = 2)
     m<- m %>% addCircleMarkers(lng=df2[which.max(df2$Meters_Interval),"Longitude"],lat=df2[which.max(df2$Meters_Interval),"Latitude"], popup=paste("Fastest Speed: ", round(df2[which.max(df2$Meters_Interval),"RunSpeed_MPH"],2), " MPH"), fillColor="Yellow", weight=1, opacity = 2)
     m
}