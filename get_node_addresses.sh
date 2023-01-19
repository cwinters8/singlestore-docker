#!/bin/bash

docker network inspect edu | jq --arg name "$1" '.[0].Containers[] | if $name != "" then select(.Name == $name) else . end | {name: .Name, address: .IPv4Address}'
