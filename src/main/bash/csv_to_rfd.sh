#!/bin/bash

# Transform csv, ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/fysico-chemisch/fysico-chemisch.csv
# to jsonld, /tmp/fysico-chemisch.jsonld
Rscript ../R/csv_to_json.R

# Make formatted jsonld and turtle
riot --formatted=TURTLE /tmp/fysico-chemisch.jsonld   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/fysico-chemisch/fysico-chemisch.ttl'
riot --formatted=JSONLD '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/fysico-chemisch/fysico-chemisch.ttl'   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/fysico-chemisch/fysico-chemisch.jsonld' 

