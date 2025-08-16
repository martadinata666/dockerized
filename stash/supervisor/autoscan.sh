#!/bin/bash
curl -X POST -H "Content-Type: application/json" --data '{ "query": "mutation { metadataScan (input:{scanGenerateCovers: true, scanGeneratePreviews: true, scanGenerateImagePreviews: true, scanGenerateSprites: true, scanGeneratePhashes: true, scanGenerateThumbnails: true, scanGenerateClipPreviews: true})}" }' localhost:9999/graphql


