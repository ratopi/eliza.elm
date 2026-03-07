#!/bin/bash

# Build script for Eliza Elm application
# Compiles Elm source code and outputs to the public directory

set -e

echo "Building Eliza Elm application..."

# Navigate to the elm directory
cd "$(dirname "$0")/elm"

# Compile Elm code to JavaScript
echo "Compiling Elm source..."
elm make src/Main.elm --optimize --output=../public/app.js

echo "Build complete! Output: public/app.js"
echo "Open public/index.html in your browser to run the application."

