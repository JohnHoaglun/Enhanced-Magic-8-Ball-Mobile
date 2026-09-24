#!/bin/bash
# Canonical local verification for Enhanced Magic 8 Ball.
set -euo pipefail
cd "$(dirname "$0")/.."

PROJECT="Enhanced Magic 8 Ball.xcodeproj"
SCHEME="Enhanced Magic 8 Ball"
# Must be a unique simulator name on this machine; override with SIMULATOR_NAME.
SIMULATOR="${SIMULATOR_NAME:-iPhone 17e}"
DERIVED_DATA=".build/verify-derived"

echo "==> Build (iOS Simulator)"
xcodebuild build \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath "$DERIVED_DATA"

echo "==> Unit tests"
xcodebuild test \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,name=$SIMULATOR" \
  -derivedDataPath "$DERIVED_DATA" \
  -only-testing:"Enhanced Magic 8 BallTests"

if [ "${SKIP_UI_TESTS:-0}" != "1" ]; then
  echo "==> UI tests"
  xcodebuild test \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "platform=iOS Simulator,name=$SIMULATOR" \
    -derivedDataPath "$DERIVED_DATA" \
    -only-testing:"Enhanced Magic 8 BallUITests"
fi

echo "==> Verification complete"
