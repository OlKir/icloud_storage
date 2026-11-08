# Veggybo maintenance fork

Upstream: https://github.com/deansyd/icloud_storage

Baseline: upstream 2.2.0, commit
`be06aa54374da0e38bd6e2b21e33d4a4da328b71`.
The MIT license and original copyright notice are retained.

## Packaging changes

- iOS Swift sources live in `ios/icloud_storage/Sources/icloud_storage`.
- The original `SwiftIcloudStoragePlugin.swift` implementation and every file
  under `lib/` are byte-for-byte identical to the baseline.
- A Swift-only `@objc(IcloudStoragePlugin)` entry point delegates to the
  original implementation, replacing the Objective-C forwarding wrapper.
  This preserves Flutter's plugin class, method/event channels, arguments,
  error codes, and transfer/progress behavior without mixing Swift and
  Objective-C in an SPM target.
- `Package.swift` exposes `icloud-storage` and depends on Flutter's generated
  local `FlutterFramework` package. SwiftPM integration targets Flutter 3.44+
  and iOS 13+; Veggybo itself requires Flutter 3.47+ and iOS 15.6+.
- CocoaPods compiles the same Swift files and packages the privacy manifest
  in `icloud_storage_privacy.bundle`. macOS CocoaPods sources are unchanged;
  this patch does not introduce macOS SwiftPM support.
- The Dart SDK upper bound is widened to <4.0.0, with no Dart implementation
  changes. Version metadata `2.2.0+veggybo.1` distinguishes fork build artifacts
  from the hosted 2.2.0 package.

## Privacy resource review

`PrivacyInfo.xcprivacy` is processed by SwiftPM and included as a CocoaPods
resource bundle. File timestamp reason `C617.1` covers metadata for files in
the app-owned iCloud container returned by the existing metadata-query API.
No user defaults, disk-space, boot-time or keyboard API categories are added.
The library has no tracking code or SDK-provider collection endpoint; the
empty collection declaration describes this library, not the host app's
overall iCloud data practices.

See [Apple's required-reason API documentation](https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api)
and [Flutter's plugin migration guide](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-plugin-authors).
Reassess the manifest whenever native APIs or data handling change.

## Validation and review

- All 23 existing Dart/API tests pass on Flutter 3.47.5.
- SwiftPM manifest evaluation, podspec Ruby syntax and privacy plist validation pass.
- A separate iOS simulator app builds with SwiftPM disabled (CocoaPods) and
  enabled (SPM), and both bundles contain the declared privacy resource.
- Veggybo builds with this fork through SPM.
- A native registration smoke check sends `delete` with missing arguments
  over the original `icloud_storage` channel and expects `E_ARG`. This does
  not access an iCloud container or alter cloud files.
- Review compares all Dart files, the relocated iOS implementation, macOS
  sources and the license against the baseline to exclude behavioral edits.

Real upload, restore and deletion of existing backups still need validation
on signed physical devices using the same container and paths. This packaging
patch preserves upstream transfer completion and observer-lifecycle behavior;
it does not claim to fix or redesign that behavior.

## Consuming and maintaining

Use a Git dependency pinned to a full reviewed commit SHA, not a moving branch.
Keep the upstream remote, review future updates against this baseline, rerun
the Dart tests and native builds through both package managers, and verify
the privacy bundle in the resulting apps. Do not patch the global pub cache.
