#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#




library(shiny)
library(caret)


NFL_DF<-read.csv("NFL_DF.csv")
NFL_DF<-subset(NFL_DF, position=="WR")
# NFL_DF<-subset(NFL_DF, position %in% c("C","CB","DE","DT","FB","FS","ILB","K","LS","NT","OC","OG","OLB","OT","P","QB","RB","SS","TE","WR"))
# NFL_DF<-subset(NFL_DF, position %in% c("C","CB","DE","DT","FB","FS","ILB","K","LS","NT","OC","OG","OLB","OT","P","QB","RB","TE","WR"))
#NFL_DF[which(NFL_DF$picktotal==0),"picktotal"]<-300

#filter out undrafted
NFL_DF<-subset(NFL_DF,picktotal!=0)
NFL_DF<-subset(NFL_DF, round!=0)


buildQBModel<-function(){
    
#    QBfit<-lm(data=NFL_DF, picktotal~heightinchestotal+ weight+fortyyd+ vertical+ broad+ wonderlic+as.factor(college)+as.factor(position)  )
 #   QBfit<-lm(data=NFL_DF, round~heightinchestotal+ weight+fortyyd+ vertical+ broad+ wonderlic+arms+hands+twentyss+threecone )
    QBfit<-glm(data=NFL_DF, round~heightinchestotal+ weight+fortyyd+ vertical+ broad+ wonderlic+arms+hands +as.factor(college))
    return((QBfit))
#    return(draftfit)
}



# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    
    QB_model<- reactive({
        
        buildQBModel()
    })
    
    observeEvent(
        eventExpr = input[["submitBtn"]],
            
        {
            qb<-data.frame(heightinchestotal=input$Inches, 
                           weight=input$Weight, 
                           fortyyd=input$Forty, 
                           vertical=input$Vertical, 
                           broad=input$Broad, 
                           wonderlic=input$Wonderlic,
                           arms=input$Arms,
                           hands=input$Hands,
 #                          twentyss=input$Shuttle,
 #                          threecone=input$ThreeCone
                           college=input$College
 #                          position=input$Position
                         )
            mod<-QB_model()    
            a<-predict(mod, newdata=qb)
            c<-predict(mod, newdata=qb, interval="confidence")
            
            if(a<0){
                a<-1
                
            }else{
                if(a>7){
                    a<-"Undrafted"
                } else{
                    a<-round(a,0)    
                }
                
            }
            
           
        df<-data.frame("Round"=a, "Confidence"=c)
            
        output$tblPred<-renderTable(df)
            
        }
        
    )
  
})
