import Foundation

public enum AllowedExtensions: Hashable, Sendable {
    case videos
    case images
    case anything
    case custom([String])

    public var values: [String] {
        switch self {
        case .videos:
            return Self.normalize([
                "mp4", "mov", "avi", "webm", "m4v", "mkv", "flv",
                "wmv", "mpg", "mpeg", "3gp", "3g2", "ts", "mts",
                "m2ts", "ogv",
            ])
        case .images:
            return Self.normalize([
                "jpg", "jpeg", "png", "gif", "webp", "avif", "svg",
                "bmp", "tif", "tiff", "ico", "heic", "heif", "jxl",
            ])
        case .anything:
            return []
        case .custom(let extensions):
            return Self.normalize(extensions)
        }
    }

    public var queryValue: String {
        values.joined(separator: ",")
    }

    public var isAnything: Bool {
        values.isEmpty
    }

    private static func normalize(_ extensions: [String]) -> [String] {
        var result: [String] = []
        for value in extensions {
            let normalized = value
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
                .trimmingCharacters(in: CharacterSet(charactersIn: "."))
            guard !normalized.isEmpty, !result.contains(normalized) else {
                continue
            }
            result.append(normalized)
        }
        return result
    }
}
