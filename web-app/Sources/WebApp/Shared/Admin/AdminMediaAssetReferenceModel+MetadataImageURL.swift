import Foundation

extension AdminMediaAssetReferenceModel {
    static func metadataImageURL(
        _ value: String?
    ) -> AdminMediaAssetReferenceModel? {
        guard
            let rawValue = value?
                .trimmingCharacters(in: .whitespacesAndNewlines),
            rawValue.isEmpty == false,
            let url = URL(string: rawValue)
        else {
            return nil
        }

        let mediaPrefix =
            AppEnvironmentStore.current.publicOrigins.mediaBaseURL
            .absoluteString
            + "/media/assets/"
        guard rawValue.hasPrefix(mediaPrefix) else {
            return nil
        }

        let encodedStorageKey = String(rawValue.dropFirst(mediaPrefix.count))
        let decodedStorageKey =
            encodedStorageKey.removingPercentEncoding ?? encodedStorageKey
        let storageKey = "media/assets/" + decodedStorageKey
        let fileName =
            url.lastPathComponent.removingPercentEncoding
            ?? url.lastPathComponent
        let fileURL = URL(fileURLWithPath: fileName)
        let baseName = fileURL.deletingPathExtension().lastPathComponent
        let type = fileURL.pathExtension

        guard baseName.isEmpty == false, type.isEmpty == false else {
            return nil
        }

        return .init(
            id: rawValue,
            storageKey: storageKey,
            baseName: baseName,
            type: type,
            title: nil,
            altText: nil,
            status: "ready"
        )
    }
}
