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
    GMSServices.provideAPIKey("AIzaSyCxfH-mghbFZVvsDb7gMafz2bxK8Thfwk4")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
