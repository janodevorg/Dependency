# Runs the commands configured in the GitHub runner for each push

if ! command -v xcbeautify &> /dev/null
then
    echo "xcbeautify could not be found."
    echo "Please install xcbeautify using Homebrew by running the following command:"
    echo "brew install xcbeautify"
    exit 1
fi

set -e
set -o pipefail
xcodebuild test -scheme "Dependency" -destination "OS=16.4,name=iPhone 14 Pro" -skipPackagePluginValidation | xcbeautify
xcodebuild test -scheme "Dependency" -destination "platform=macOS,arch=arm64" -skipPackagePluginValidation | xcbeautify
xcodebuild test -scheme "Dependency" -destination "platform=macOS,arch=arm64,variant=Mac Catalyst" -skipPackagePluginValidation | xcbeautify
xcodebuild test -scheme "Dependency" -destination "platform=tvOS Simulator,OS=16.4,name=Apple TV 4K (3rd generation)" -skipPackagePluginValidation | xcbeautify
