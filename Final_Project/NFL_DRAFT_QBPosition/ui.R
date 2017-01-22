#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


NFL_DF<-read.csv("NFL_DF.csv")
NFL_DF<-subset(NFL_DF, position=="WR")
# NFL_DF<-subset(NFL_DF, position %in% c("C","CB","DE","DT","FB","FS","ILB","K","LS","NT","OC","OG","OLB","OT","P","QB","RB","SS","TE","WR"))
# NFL_DF<-subset(NFL_DF, position %in% c("C","CB","DE","DT","FB","FS","ILB","K","LS","NT","OC","OG","OLB","OT","P","QB","RB","TE","WR"))
#NFL_DF[which(NFL_DF$picktotal==0),"picktotal"]<-300

#filter out undrafted
NFL_DF<-subset(NFL_DF,picktotal!=0)
NFL_DF<-subset(NFL_DF, round!=0)
# Define UI for application that draws a histogram
shinyUI(navbarPage("NFL Wide Receiver Draft Pick Analysis",
                   tabPanel("Predict Selection Round",      
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel( width=7,
                    h2("Adjust the Combine Results To Determine Likely Draft Round"),
       fluidRow(
           splitLayout(cellWidths =c("50%","50%"),
           sliderInput("Inches",
                   "Height (Inches):",
                   min = 60,
                   max = 80,
                   value = 72),
           sliderInput("Weight",
                       "Weight(lbs):",
                       min = 170,
                       max = 270,
                       value = 200)
           
    )),
    fluidRow(
        splitLayout(cellWidths =c("50%","50%"),
                    sliderInput("Arms",
                                "Arm Length (Inches):",
                                min = 25,
                                max = 35,
                                value = 31),
                    sliderInput("Hands",
                                "Hand Size(Inches):",
                                min = 8.5,
                                max = 11.0,
                                value = 9.7)
                    
        )),
        fluidRow(
        splitLayout(cellWidths =c("50%","50%"),
                    sliderInput("Forty",
                                "Forty Yard Dash Time (seconds):",
                                min = 4.0,
                                max = 5.0,
                                value = 4.5),
                    sliderInput("Vertical",
                                "Vertical Jump (inches):",
                                min = 0,
                                max = 40,
                                value = 25)
                    
        )),
    
    fluidRow(
        splitLayout(cellWidths =c("50%","50%"),
                    sliderInput("Broad",
                                "Broad Jump(inches):",
                                min = 100,
                                max = 150,
                                value = 125),
                    sliderInput("Wonderlic",
                                "Wonderlic Score:",
                                min = 0,
                                max = 50,
                                value = 25)
                    
        )),    
#    fluidRow(
#        splitLayout(cellWidths =c("50%","50%"),
#                    sliderInput("Shuttle",
#                                "Shuttle Time(seconds):",
#                                min = 4,
#                                max = 5,
#                                value = 4.5),
#                    sliderInput("ThreeCone",
#                                "Three Cone Run (seconds)",
#                                min = 6.5,
#                                max = 7.5,
#                                value = 7)
                    
 #       )),
#    selectInput("Position", label = h3("Select Position"),
#                           choices=sort(unique(NFL_DF$position))
#        ),
    selectInput("College", label = h3("Select College"),
                choices=sort(unique(NFL_DF$college))
                             ),
    
    actionButton(
        inputId = "submitBtn",
        label = "Get Likely Draft Position"
             )
    ),
    # Show a plot of the generated distribution
    mainPanel(
       h2("Likely Draft Selection"),
       tableOutput("tblPred")
       
    )
  )
),
tabPanel("Info",
         mainPanel( h2("Predicting a Players's Draft Round"),
                    div("Every year the NFL holds its combine where college football players showcase their abilities, in hopes of being drafted by an NFL team.
                        This app is using combine/draft results and creates a predictive model on 15 years of results for Wide Recievers.  Use the sliders and selectors to change 
                        features of a player to determine where that position would likely get drafted (if at all).  You can effect the individuals Height, Weight,
                        Forty Yard Dash time, vertical jump, broad jump, wonderlic test score, and college"))
)
        ))