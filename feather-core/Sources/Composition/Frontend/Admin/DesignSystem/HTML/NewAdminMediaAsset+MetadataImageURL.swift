import FeatherContracts
import Foundation

extension NewAdminMediaAsset {
    public static func metadataImageURL(
        _ value: String?
    ) -> NewAdminMediaAsset? {
        guard
            let rawValue = value?
                .whitespaceTrimmed,
            rawValue.isEmpty == false,
            let url = URL(string: rawValue)
        else {
            return nil
        }

        guard let mediaPrefix = unsafe AppEnvironmentStore.current.mediaResolver
            .resolve(imagePath: "/media/assets/")
        else {
            return nil
        }
        guard rawValue.hasPrefix(mediaPrefix) else {
            return nil
        }

        let relativePath = String(rawValue.dropFirst(mediaPrefix.count))
        let decodedPath = relativePath.removingPercentEncoding ?? relativePath
        let pathComponents = decodedPath.split(
            separator: "/",
            omittingEmptySubsequences: true
        )
        guard pathComponents.count >= 2 else { return nil }
        let id = String(pathComponents[0])
        let fileName =
            url.lastPathComponent.removingPercentEncoding
            ?? url.lastPathComponent
        let fileURL = URL(fileURLWithPath: fileName)
        let name = fileURL.deletingPathExtension().lastPathComponent
        let `extension` = fileURL.pathExtension
        let relativeAssetPath = pathComponents.dropFirst().map(String.init)
            .joined(separator: "/")
        let slugPath = String(relativeAssetPath.dropLast(`extension`.count + 1))

        guard name.isEmpty == false, `extension`.isEmpty == false else {
            return nil
        }

        return .init(
            id: id,
            name: name,
            slugPath: slugPath,
            url: rawValue,
            extension: `extension`,
            contentType: "",
            sizeBytes: 0,
            title: nil,
            altText: nil,
            status: "ready"
        )
    }
}
