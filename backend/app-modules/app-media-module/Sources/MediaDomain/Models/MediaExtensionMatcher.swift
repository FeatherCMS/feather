import Foundation

public enum MediaExtensionMatcher {
    public static func matches(
        asset: MediaAsset,
        processor: MediaProcessor
    ) -> Bool {
        matches(
            storageKey: asset.storageKey,
            type: asset.type,
            processor: processor
        )
    }

    public static func matches(
        storageKey: String,
        type: String,
        processor: MediaProcessor
    ) -> Bool {
        let assetExtension =
            storageKeyExtension(storageKey)
            ?? canonicalExtension(from: type)
            ?? "bin"

        let acceptedExtensions = processor.matchExtensions
            .components(separatedBy: CharacterSet(charactersIn: ",; \n\r\t"))
            .compactMap { canonicalExtension(from: String($0)) }
            .filter { !$0.isEmpty }

        return acceptedExtensions.contains(assetExtension)
    }

    public static func canonicalExtension(
        from value: String
    ) -> String? {
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        guard !normalized.isEmpty else { return nil }

        let strippedPrefix =
            normalized.hasPrefix(".")
            ? String(normalized.drop(while: { $0 == "." }))
            : normalized
        let rawExtension =
            strippedPrefix.contains("/")
            ? (strippedPrefix.split(separator: "/").last.map(String.init)
                ?? strippedPrefix)
            : strippedPrefix

        switch rawExtension {
        case "jpg", "jpeg":
            return "jpeg"
        default:
            return rawExtension
        }
    }

    public static func storageKeyExtension(
        _ storageKey: String
    ) -> String? {
        let fileName =
            storageKey.split(separator: "/").last.map(String.init) ?? storageKey
        guard let dotIndex = fileName.lastIndex(of: "."),
            dotIndex < fileName.index(before: fileName.endIndex)
        else {
            return nil
        }
        let ext = String(fileName[fileName.index(after: dotIndex)...])
            .lowercased()
        return canonicalExtension(from: ext)
    }
}
