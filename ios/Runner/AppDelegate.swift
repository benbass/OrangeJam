import UIKit
import Flutter
import MediaPlayer
import awesome_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)


    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "orangejam_music_dir", binaryMessenger: controller.binaryMessenger)

      channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in if call.method == "getMusicLibrary" {
          MusicLibraryManager.shared.requestAuthorization {
              authorized in if authorized {
                  let songs = MusicLibraryManager.shared.fetchSongs()
                  result(songs)
              } else {
                  result(FlutterError(code: "UNAUTHORIZED", message: "Authorization denied", details: nil))
              }
          }
      } else {
          result(FlutterMethodNotImplemented)
      }
      }




    // This function registers the desired plugins to be used within a notification background action
    SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
        SwiftAwesomeNotificationsPlugin.register(
            with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
