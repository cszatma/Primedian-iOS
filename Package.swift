// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Primedian-iOS",
    dependencies: [
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.6.0"),
        .package(url: "https://github.com/orta/Komondor.git", from: "1.0.0"),
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "post-checkout": "swift run xcodegen generate -s ./project.yml"
        ],
    ]).write()
#endif
