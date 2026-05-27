#!/bin/bash

echo "Building Social Engineering Toolkit..."
echo "NOTE: This requires Xcode command line tools"

# Check for Xcode
if ! xcodebuild -version &> /dev/null; then
    echo "Error: Xcode not found. Please install Xcode from Mac App Store"
    exit 1
fi

# Create build directory
mkdir -p build

# Compile (simplified - use Xcode project for full build)
echo "Please open SocialEngineeringToolkit.xcodeproj in Xcode to build"
echo "Or use: xcodebuild -project SocialEngineeringToolkit.xcodeproj -scheme SocialEngineeringToolkit build"

# Make scripts executable
chmod +x build.sh

echo "Build preparation complete"
