import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Add your Google Maps API Key here
    GMSServices.provideAPIKey("YOUR KEY HERE")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
