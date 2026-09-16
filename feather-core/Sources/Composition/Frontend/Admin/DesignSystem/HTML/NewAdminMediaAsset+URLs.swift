import Foundation

extension NewAdminMediaAsset {
    public var originalURL: String {
        Self.mediaURL(storageKey: storageKey, isVariant: false)
    }

    public var previewURL: String? {
        guard let previewStorageKey, !previewStorageKey.isEmpty else {
            return nil
        }
        return Self.mediaURL(
            storageKey: previewStorageKey,
            isVariant: true
        )
    }

    public static func mediaURL(
        storageKey: String,
        isVariant: Bool
    ) -> String {
        let route = isVariant ? "/media/variants/" : "/media/assets/"
        return
            "\(AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString)\(route)\(encodedStorageKey(storageKey))"
    }

    private static func encodedStorageKey(_ key: String) -> String {
        let normalizedKey = normalizedStorageKey(key)
        let allowed = CharacterSet(
            charactersIn:
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/"
        )
        return normalizedKey.addingPercentEncoding(
            withAllowedCharacters: allowed
        )
            ?? normalizedKey
    }
}
