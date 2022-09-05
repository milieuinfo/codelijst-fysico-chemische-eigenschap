#!/usr/bin/Rscript
library(tidyr)
library(dplyr)
library(jsonlite)
setwd("/home/gehau/git/codelijst-fysico-chemische_parameter/src/main/R")

df <- read.csv(file = "../resources/be/vlaanderen/omgeving/data/id/conceptscheme/fysico-chemische_parameter/fysico-chemische_parameter.csv", sep=",", na.strings=c("","NA"))

tco <- subset(df, topConceptOf == 'https://data.omgeving.vlaanderen.be/id/conceptscheme/fysico-chemische_parameter' ,
                   select=c(uri, topConceptOf))
htc <- as.list(tco["uri"])
df2 <- data.frame('https://data.omgeving.vlaanderen.be/id/conceptscheme/fysico-chemische_parameter', htc)
names(df2) <- c("uri","hasTopConcept")
df <- bind_rows(df, df2)


df <- df %>%
  rename("@id" = uri,
         "@type" = type)
write.csv(df,"../resources/be/vlaanderen/omgeving/data/id/conceptscheme/fysico-chemische_parameter/fysico-chemische_parameter_separate_rows.csv", row.names = FALSE)
context <- jsonlite::read_json("../resources/be/vlaanderen/omgeving/data/id/conceptscheme/fysico-chemische_parameter/context.json")
df_in_list <- list('@graph' = df, '@context' = context)
df_in_json <- toJSON(df_in_list, auto_unbox=TRUE)
write(df_in_json, "/tmp/fysico-chemische_parameter.jsonld")

