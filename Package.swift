// swift-tools-version: 5.9
//
// aparte-privacy for Swift: finds personal data (names, addresses, emails, phone numbers,
// URLs, dates, account numbers) in text, on-device, offline. Same model file and same spans as
// the JavaScript runtime (@aparte/privacy on npm) and the Python reader.

import PackageDescription

let package = Package(
    name: "ApartePrivacy",
    platforms: [
        .iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1),
    ],
    products: [
        // The runtime and the int8 model (196 KB), ready to use.
        .library(name: "ApartePrivacy", targets: ["ApartePrivacy"]),
    ],
    targets: [
        .target(
            name: "ApartePrivacy",
            resources: [.copy("Resources/privacy-v1.1-int8.bin")]
        ),
        .testTarget(name: "ApartePrivacyTests", dependencies: ["ApartePrivacy"]),
    ]
)
