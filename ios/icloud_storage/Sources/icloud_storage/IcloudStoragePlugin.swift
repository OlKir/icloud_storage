import Flutter

// Keep the existing Flutter registration class and the original implementation
// in one Swift module, which both SwiftPM and CocoaPods can compile.
@objc(IcloudStoragePlugin)
public class IcloudStoragePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    SwiftIcloudStoragePlugin.register(with: registrar)
  }
}
