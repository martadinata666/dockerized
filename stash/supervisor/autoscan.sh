#!/bin/bash
curl -X POST -H "Content-Type: application/json" --data '{ "query": "mutation { metadataScan (input:{rescan: true})}" }' localhost:9999/graphql


