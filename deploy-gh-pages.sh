#!/bin/bash

# Script to deploy MkDocs site to gh-pages branch

echo "Building MkDocs site..."
mkdocs build

if [ $? -ne 0 ]; then
    echo "Build failed. Exiting."
    exit 1
fi

echo "Deploying to gh-pages branch..."
mkdocs gh-deploy --force

echo "Deployment complete! Your site should be available at:"
echo "https://arpit20250701.github.io/hackathon-docs/"
