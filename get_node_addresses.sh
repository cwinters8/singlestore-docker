#!/bin/bash

docker network inspect edu | jq ".[0].Containers[]" | jq "{name: .Name, address: .IPv4Address}"
