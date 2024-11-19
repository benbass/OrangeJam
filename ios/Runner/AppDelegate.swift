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

    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method {
            
            case "getSongData":
            let query = MPMediaQuery.songs()
            var songs: [[String: Any?]] = []

            if let items = query.items {
                for item in items {
                    var song: [String: Any?] = [:]
                    song["assetUrl"] = (item.value(forProperty: MPMediaItemPropertyAssetURL) as? URL)?.absoluteString
                    song["title"] = item.value(forProperty: MPMediaItemPropertyTitle) as? String
                    song["artist"] = item.value(forProperty: MPMediaItemPropertyArtist) as? String
                    song["album"] = item.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String
                    song["trackNumber"] = item.value(forProperty: MPMediaItemPropertyAlbumTrackNumber) as? Int
                    song["albumLength"] = item.value(forProperty: MPMediaItemPropertyAlbumTrackCount) as? Int
                    if let releaseDate = item.value(forProperty: MPMediaItemPropertyReleaseDate) as? Date {
                        let calendar = Calendar.current
                        let year = calendar.component(.year, from: releaseDate)
                        song["year"] = year
                    } else {
                        song["year"] = nil
                    }
                    song["genre"] = item.value(forProperty: MPMediaItemPropertyGenre) as? String
                    if let duration = item.value(forProperty: MPMediaItemPropertyPlaybackDuration) as? NSNumber {
                        song["duration"] = duration.doubleValue // Convert NSNumber to Double
                    } else {
                        song["duration"] = 0
                    }
                    if let artwork = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
                        if let image = artwork.image(at: CGSize(width: 256, height: 256)) {
                            if let imageData = image.pngData() {
                                // Convert Data to Uint8List
                                //let uint8List = Array(imageData)
                                song["albumArt"] = imageData
                            }
                        }
                    } else {
                        song["albumArt"] = nil
                    }
                    song["albumArtist"] = item.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String
                    songs.append(song)
                }
            }
            result(songs)
            
        case "getTempFilePath":
                if let arguments = call.arguments as? [String: Any],
                   let assetUrlString = arguments["assetUrl"] as? String,
                   let assetURL = URL(string: assetUrlString) {
                    let asset = AVURLAsset(url: assetURL)
                    
                    let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough)
                    let tempDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
                    let path = tempDirectory[0]
                    let id = UUID().uuidString
                    let outputURL = path.appendingPathComponent("\(id).caf")
                    
                    exportSession?.outputURL = outputURL
                    exportSession?.outputFileType = AVFileType.caf
                    
                    exportSession?.exportAsynchronously(completionHandler: {[weak exportSession]
                        () -> Void in
                        if exportSession!.status == AVAssetExportSession.Status.completed  {
                            let s = "\(id).caf"
                            result(s)
                        } else {
                            print("Export failed: \(String(describing: exportSession?.error))")
                            result(nil)
                        }
                    })
                    
                    
                    
                } else {
                    result(FlutterError(code: "INVALID_ASSET_URL", message: "Ungültige Asset-URL", details: nil))
                }
            
            default:
                result(FlutterMethodNotImplemented)
            }

    })
      
    
      

    // This function registers the desired plugins to be used within a notification background action
    SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
        SwiftAwesomeNotificationsPlugin.register(
            with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
