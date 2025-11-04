#!/bin/bash

# Script to manually update Godot version in Dockerfile
# Usage: ./scripts/update-godot-version.sh <version>

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <godot-version>"
    echo "Example: $0 4.4.1"
    exit 1
fi

NEW_VERSION=$1
DOCKERFILE="Dockerfile.godot-dev"

# Check if Dockerfile exists
if [ ! -f "$DOCKERFILE" ]; then
    echo "Error: $DOCKERFILE not found"
    exit 1
fi

# Get current version
CURRENT_VERSION=$(grep "ARG GODOT_VERSION=" "$DOCKERFILE" | cut -d'=' -f2)

echo "Current version: $CURRENT_VERSION"
echo "New version: $NEW_VERSION"

# Validate version format (basic check)
if ! [[ $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid version format. Expected format: X.Y.Z (e.g., 4.4.1)"
    exit 1
fi

# Update the version
sed -i "s/ARG GODOT_VERSION=.*/ARG GODOT_VERSION=$NEW_VERSION/" "$DOCKERFILE"

echo "✓ Successfully updated $DOCKERFILE to Godot version $NEW_VERSION"

# Verify the change
NEW_VERSION_CHECK=$(grep "ARG GODOT_VERSION=" "$DOCKERFILE" | cut -d'=' -f2)
if [ "$NEW_VERSION_CHECK" == "$NEW_VERSION" ]; then
    echo "✓ Version update verified"
else
    echo "⚠ Warning: Version verification failed"
    exit 1
fi
