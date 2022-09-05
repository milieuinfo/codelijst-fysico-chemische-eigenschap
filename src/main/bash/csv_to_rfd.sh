#!/bin/bash

# Transform csv, ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/fysico-chemische_parameter/fysico-chemische_parameter.csv
# to jsonld, /tmp/fysico-chemische_parameter.jsonld
Rscript ../R/csv_to_json.R

# Make formatted jsonld and turtle
riot --formatted=TURTLE /tmp/fysico-chemische_parameter.jsonld   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/fysico-chemische_parameter/fysico-chemische_parameter.ttl'
riot --formatted=JSONLD '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/fysico-chemische_parameter/fysico-chemische_parameter.ttl'   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/fysico-chemische_parameter/fysico-chemische_parameter.jsonld' 

