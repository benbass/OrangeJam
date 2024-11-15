import MediaPlayer
import Flutter

class MusicLibraryManager: NSObject {
    static let shared = MusicLibraryManager()

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        MPMediaLibrary.requestAuthorization { status in
            completion(status == .authorized)
        }
    }

    func fetchSongs() -> [[String: String]] {
        let query = MPMediaQuery.songs()
        let songs = query.items?.map {item in
         return [
         "title": item.title ?? "Unknown Title",
         "artist": item.artist ?? "Unknown Artist",
         "filePath": item.assetURL?.absoluteString ?? "Unknown Path"
         ]
         } ?? []
        return songs
    }
}
