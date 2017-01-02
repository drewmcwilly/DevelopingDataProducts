library(tidyr)



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
