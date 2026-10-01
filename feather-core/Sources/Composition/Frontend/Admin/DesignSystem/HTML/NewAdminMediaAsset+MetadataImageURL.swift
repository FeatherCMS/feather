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

        let pathComponents =
            url.path.removingPercentEncoding
            .map { $0.split(separator: "/", omittingEmptySubsequences: true) }
            ?? url.path.split(separator: "/", omittingEmptySubsequences: true)
        guard let markerIndex = pathComponents.firstIndex(of: "originals"),
            markerIndex > 0,
            markerIndex + 1 < pathComponents.endIndex
        else { return nil }

        let prefixComponents = pathComponents[..<markerIndex]
        let id = prefixComponents.map(String.init).joined()
        let virtualComponents = pathComponents[(markerIndex + 1)...]
        let fileName = String(virtualComponents.last!)
        let fileURL = URL(fileURLWithPath: fileName)
        let name = fileURL.deletingPathExtension().lastPathComponent
        let `extension` = fileURL.pathExtension
        let folderPath = virtualComponents.dropLast().map(String.init)
            .joined(separator: "/")
        var slug = ""
        var pendingSeparator = false
        for scalar in name.lowercased().unicodeScalars {
            if (97...122).contains(scalar.value)
                || (48...57).contains(scalar.value)
            {
                if pendingSeparator, !slug.isEmpty { slug.append("-") }
                slug.unicodeScalars.append(scalar)
                pendingSeparator = false
            }
            else if !slug.isEmpty {
                pendingSeparator = true
            }
        }
        let slugPath = [folderPath, slug].filter { !$0.isEmpty }
            .joined(separator: "/")

        guard !id.isEmpty, !name.isEmpty, !`extension`.isEmpty else {
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
