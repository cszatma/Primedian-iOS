.DEFAULT_GOAL = xcode

# Get carthage dependencies
carthage:
	carthage bootstrap --platform iOS --no-use-binaries --use-ssh --cache-builds
.PHONY: carthage

# Generate xcode project
xcode:
	swift run xcodegen generate
.PHONY: xcode

# Install git hooks
hooks:
	swift run komondor install
.PHONY: hooks
