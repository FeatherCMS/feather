import Foundation

extension NewAdminMediaAsset {
    public static func mediaURL(path: String) -> String {
        guard let url = URL(string: path), url.scheme != nil else {
            return AppEnvironmentStore.current.publicOrigins.mediaBaseURL
                .appendingPathComponent(path.hasPrefix("/") ? String(path.dropFirst()) : path)
                .absoluteString
        }
        return path
    }
}
