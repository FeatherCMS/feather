public import Foundation

public struct MediaURLVariant: Sendable, Equatable, Hashable {
    public let key: String
    public let url: String

    public init(key: String, url: String) {
        self.key = key
        self.url = url
    }
}

public struct MediaResolver: Sendable {
    public let mediaBaseURL: URL

    public init(mediaBaseURL: URL) {
        self.mediaBaseURL = mediaBaseURL
    }

    public func resolve(imagePath: String) -> String? {
        guard !imagePath.isEmpty else { return nil }
        if let url = URL(string: imagePath), url.scheme != nil {
            return imagePath
        }

        let base = mediaBaseURL.absoluteString.hasSuffix("/")
            ? String(mediaBaseURL.absoluteString.dropLast())
            : mediaBaseURL.absoluteString
        let path = imagePath.hasPrefix("/")
            ? imagePath
            : "/\(imagePath)"
        return base + path
    }

    public func resolve(
        variants: [MediaURLVariant],
        variantKey: String
    ) -> String? {
        guard let variant = variants.first(where: { $0.key == variantKey })
        else {
            return nil
        }
        return resolve(imagePath: variant.url)
    }

    public func resolveMarkdownImages(in source: String) -> String {
        let marker = "/media/assets/"
        var result = source
        var searchStart = result.startIndex

        while let markerRange = result.range(
            of: marker,
            range: searchStart..<result.endIndex
        ) {
            let isPathStart: Bool = {
                guard markerRange.lowerBound > result.startIndex else {
                    return true
                }
                let previous = result[
                    result.index(before: markerRange.lowerBound)
                ]
                return !previous.isLetter && !previous.isNumber
                    && !"/:._-".contains(previous)
            }()
            guard isPathStart else {
                searchStart = markerRange.upperBound
                continue
            }

            var pathEnd = markerRange.upperBound
            while pathEnd < result.endIndex {
                let character = result[pathEnd]
                guard
                    character.isLetter || character.isNumber
                        || "._~/%+-".contains(character)
                else { break }
                pathEnd = result.index(after: pathEnd)
            }

            let path = String(result[markerRange.lowerBound..<pathEnd])
            let resolvedPath = resolve(imagePath: path) ?? path
            result.replaceSubrange(
                markerRange.lowerBound..<pathEnd,
                with: resolvedPath
            )
            searchStart = result.index(
                result.startIndex,
                offsetBy: result.distance(
                    from: result.startIndex,
                    to: markerRange.lowerBound
                ) + resolvedPath.count
            )
        }
        return result
    }
}
