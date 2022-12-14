library(xml2)
library(tidyr)
library(dplyr)
library(jsonlite)
library(data.table)
library(stringr)


#setwd('/home/gehau/git/codelijst-fysico-chemische-eigenschap/src/main/R')


artifactory <- "https://repo.omgeving.vlaanderen.be/artifactory/release"

# read pom.xml 
x <- read_xml("../../../pom.xml")
xml_ns_strip( x )
groupId <- xml_text( xml_find_first(x, "/project/groupId") )
artifactId <- xml_text( xml_find_first(x, "/project/artifactId") )
version <- xml_text( xml_find_first(x, "/project/version") )
name <- xml_text( xml_find_first(x, "/project/name") )

class_path  <- gsub("\\.","/", groupId) 
version_next_release <- strsplit(version, '-')[[1]][1]
packageFileName_ <- paste(name,'-',version_next_release,'.jar', sep = "")
packageName_ <- paste(groupId, name, sep = ".")
package_id <- paste("omg_package", packageName_, sep = ":")
downloadLocation_ <- paste(artifactory, class_path, name, version_next_release, packageFileName_, sep = "/")


df <- read.csv(file = "../resources/be/vlaanderen/omgeving/data/id/dataset/codelijst-fysico-chemische-eigenschap/catalog.csv", sep=",", na.strings=c("","NA"))
df <- df %>%
  mutate_all(list(~ str_c("", .)))
setDT(df)[type == "dcat:Dataset", owl.versionInfo := version_next_release]
setDT(df)[type == "dcat:Distribution", owl.versionInfo := version_next_release]
write.csv(df,"../resources/be/vlaanderen/omgeving/data/id/dataset/codelijst-fysico-chemische-eigenschap/catalog.csv", row.names = FALSE)

for(col in 1:ncol(df)) {   # for-loop over columns
  df <- df %>%
    separate_rows(col, sep = "\\|")
}
df <- df %>% rename(
  "@id" = id,
  "@type" = type
)
context <- jsonlite::read_json("../resources/be/vlaanderen/omgeving/data/id/dataset/codelijst-fysico-chemische-eigenschap/context.json")
df_in_list <- list('@graph' = df, '@context' = context)
df_in_json <- toJSON(df_in_list, auto_unbox=TRUE)
write(df_in_json, "/tmp/catalog.jsonld")
system("riot --formatted=TURTLE /tmp/catalog.jsonld > ../resources/be/vlaanderen/omgeving/data/id/dataset/codelijst-fysico-chemische-eigenschap/catalog.ttl")
system("riot --formatted=JSONLD ../resources/be/vlaanderen/omgeving/data/id/dataset/codelijst-fysico-chemische-eigenschap/catalog.ttl > ../resources/be/vlaanderen/omgeving/data/id/dataset/codelijst-fysico-chemische-eigenschap/catalog.jsonld")

