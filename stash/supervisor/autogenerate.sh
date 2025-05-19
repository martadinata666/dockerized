#!/bin/bash
curl -X POST -H "Content-Type: application/json" --data '{ "query": "mutation { metadataGenerate (input:{covers: true, sprites: true, previews: true,imagePreviews: true, imageThumbnails: true, clipPreviews: true})}" }' localhost:9999/graphql

