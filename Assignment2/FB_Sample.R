library(httr)
library(tidyr)


# 1. Set up credentials
fitbit_endpoint <- oauth_endpoint(
    request = "https://api.fitbit.com/oauth2/token",
    authorize = "https://www.fitbit.com/oauth2/authorize",
    access = "https://api.fitbit.com/oauth2/token")
myapp <- oauth_app(
    appname = "data_access",
    key = "<Client Key Required>", 
    secret = "<Secret Required>")
# 2. Get OAuth token
scope <- c("sleep","activity")  # See dev.fitbit.com/docs/oauth2/#scope
fitbit_token <- oauth2.0_token(fitbit_endpoint, myapp,
                               scope = scope, use_basic_auth = TRUE)



    steps_range<- GET (url ="https://api.fitbit.com/1/user/-/activities/steps/date/2016-08-01/2016-08-31.json", 
                   config(token = fitbit_token))
    sr<-content(steps_range)
    ls_date=list()
    ls_steps=list()
    ls_l_active=list()
    ls_f_active=list()
    ls_v_active=list()
    ls_distance=list()
    ls_calorie=list()
    for (x in 1:length(sr[[1]])){
        
        ls_date[[x]]<-sr[[1]][[x]]$dateTime
        ls_steps[[x]]<- sr[[1]][[x]]$value
        
    }
mla_range<- GET (url ="https://api.fitbit.com/1/user/-/activities/minutesLightlyActive/date/2016-08-01/2016-08-31.json", 
                 config(token = fitbit_token))
    mla<-content(mla_range)
    
    
    for (x in 1:length(mla[[1]])){
        
        
        ls_l_active[[x]]<- mla[[1]][[x]]$value
        
    }

mfa_range<- GET (url ="https://api.fitbit.com/1/user/-/activities/minutesFairlyActive/date/2016-08-01/2016-08-31.json", 
                 config(token = fitbit_token))
mfa<-content(mfa_range)


    for (x in 1:length(mfa[[1]])){
        
        
        ls_f_active[[x]]<- mfa[[1]][[x]]$value
        
    }

mva_range<- GET (url ="https://api.fitbit.com/1/user/-/activities/minutesVeryActive/date/2016-08-01/2016-08-31.json", 
                 config(token = fitbit_token))
mva<-content(mva_range)


    for (x in 1:length(mva[[1]])){
        
        
        ls_v_active[[x]]<- mva[[1]][[x]]$value
        
}    


Distance_range<- GET (url ="https://api.fitbit.com/1/user/-/activities/distance/date/2016-08-01/2016-08-31.json", 
                      config(token = fitbit_token))
dr<-content(Distance_range)


    for (x in 1:length(dr[[1]])){
        
        
        ls_distance[[x]]<- dr[[1]][[x]]$value
        
    }


calorie_range<- GET (url ="https://api.fitbit.com/1/user/-/activities/calories/date/2016-08-01/2016-08-31.json", 
                     config(token = fitbit_token))
cr<-content(calorie_range)


    for (x in 1:length(cr[[1]])){
        
        
        ls_calorie[[x]]<- cr[[1]][[x]]$value
        
    }


    df<-do.call(rbind, Map(data.frame, date=ls_date, Calories=ls_calorie, Steps=ls_steps))
    df2<-do.call(rbind, Map(data.frame, date=ls_date, Distance=ls_distance, Minutes_Lightly_Active=ls_l_active, 
                            Minutes_Fairly_Active=ls_f_active, Minutes_Very_Active=ls_v_active))
    
    
    
    df$date<-as.POSIXct(df$date)
    df$Steps<-as.numeric(as.character(df$Steps))
    df$Calories<-as.numeric(as.character(df$Calories))
    
    
    
    df2$date<-as.POSIXct(df2$date)
    df2$Distance<-as.numeric(as.character(df2$Distance))
    df2$Minutes_Lightly_Active<-as.numeric(as.character(df2$Minutes_Lightly_Active))
    df2$Minutes_Fairly_Active<-as.numeric(as.character(df2$Minutes_Fairly_Active))
    df2$Minutes_Very_Active<-as.numeric(as.character(df2$Minutes_Very_Active))



    gdf<-gather(df,measurement, value, 2:3)
    gdf2<-gather(df2,measurement, value, 2:5)

library(plotly)
    plot_ly(gdf, x = gdf$date, y = gdf$value, mode='lines' ,color = gdf$measurement)
    
    plot_ly(gdf2, x = gdf2$date, y = gdf2$value, mode = 'lines',color = gdf2$measurement)

#plotly library seems to interfere with the ability to retrieve data from the APIs
detach("package:plotly", unload=TRUE)
