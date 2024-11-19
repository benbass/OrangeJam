import MediaPlayer
import Flutter

class MusicLibraryManager: NSObject {
    static let shared = MusicLibraryManager()

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        MPMediaLibrary.requestAuthorization { status in
            completion(status == .authorized)
        }
    }

}
