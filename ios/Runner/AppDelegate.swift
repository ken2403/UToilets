import UIKit
import Flutter
import GoogleMaps  // Add this import for Google map

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Add Kento Nishio's Google Maps API key
    GMSServices.provideAPIKey("AIzaSyBX5G9F4fN-NxZ3SmKxEQXT9SWXpMhqOlU")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
