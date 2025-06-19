#!/bin/bash
# Exit immediately if any command fails.
set -e

#####################################
# Configuration - MODIFY THESE VALUES
#####################################

# Your Firebase App ID (find this in your Firebase console, e.g., "1:1234567890:android:abcdefg")
FIREBASE_APP_ID="1:103293712511:android:d9782a98eb16dcef14674a"

# Comma-separated list of tester groups (or emails) you want to distribute to.
# For example, if you have a tester group named "beta-testers":
TESTER_GROUPS="beta-testers"

# Release notes (you can customize this or pull it from elsewhere)
RELEASE_NOTES="Automated build distributed on $(date '+%Y-%m-%d %H:%M:%S')"

# Path to the APK output (adjust if you build an app bundle or have a different path)
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

#####################################
# End Configuration
#####################################

# Function to update the version in pubspec.yaml by incrementing the build number by 1.
update_version() {
  echo "----------------------------------------"
  echo "Updating version in pubspec.yaml..."
  echo "----------------------------------------"

  # Check if pubspec.yaml exists.
  if [ ! -f "pubspec.yaml" ]; then
    echo "Error: pubspec.yaml not found!"
    exit 1
  fi

  # Extract the current version line.
  VERSION_LINE=$(grep '^version:' pubspec.yaml || true)
  if [ -z "$VERSION_LINE" ]; then
    echo "Error: No version field found in pubspec.yaml."
    exit 1
  fi

  echo "Current version line: $VERSION_LINE"

  # Use Bash regex to parse the version.
  # Expected format: version: MAJOR.MINOR.PATCH+BUILD (e.g., version: 1.0.0+1)
  if [[ $VERSION_LINE =~ version:\ ([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+) ]]; then
    MAJOR="${BASH_REMATCH[1]}"
    MINOR="${BASH_REMATCH[2]}"
    PATCH="${BASH_REMATCH[3]}"
    BUILD="${BASH_REMATCH[4]}"

    # Increment the build number by 1.
    NEW_BUILD=$((BUILD + 1))
    NEW_PATCH="$((PATCH + 1))"
    NEW_VERSION="${MAJOR}.${MINOR}.${NEW_PATCH}+${NEW_BUILD}"

    echo "New version will be: ${NEW_VERSION}"

    # Update pubspec.yaml with the new version.
    # Create a backup of pubspec.yaml as pubspec.yaml.bak.
    sed -i.bak "s/^version: .*/version: ${NEW_VERSION}/" pubspec.yaml
    echo "pubspec.yaml updated successfully."
  else
    echo "Error: Could not parse the version string. Ensure it is in the format: MAJOR.MINOR.PATCH+BUILD"
    exit 1
  fi
}

#####################################
# Main Script
#####################################

# 1. Update the version in pubspec.yaml.
update_version

echo "----------------------------------------"
echo "Fetching Flutter packages..."
echo "----------------------------------------"
flutter pub get

# 3. Build the Flutter APK in release mode.
echo "----------------------------------------"
echo "Building Flutter APK in release mode..."
echo "----------------------------------------"
flutter build apk --release

# Verify that the APK was created.
if [ ! -f "$APK_PATH" ]; then
  echo "Error: APK not found at '$APK_PATH'. Please check your build configuration."
  exit 1
fi

# 4. Distribute the APK using Firebase App Distribution CLI.
echo "----------------------------------------"
echo "Distributing APK to Firebase App Distribution..."
echo "----------------------------------------"
firebase appdistribution:distribute "$APK_PATH" \
  --app "$FIREBASE_APP_ID" \
  --groups "$TESTER_GROUPS" \
  --release-notes "$RELEASE_NOTES"

echo "----------------------------------------"
echo "Distribution complete!"
echo "----------------------------------------"
