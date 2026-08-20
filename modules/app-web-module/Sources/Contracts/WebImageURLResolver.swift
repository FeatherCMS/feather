import Foundation

public enum WebImageURLResolver {
    public static func resolve(
        _ imageURL: String,
        mediaBaseURL: String
    ) -> String {
        guard !imageURL.isEmpty else { return imageURL }
        guard
            !imageURL.hasPrefix("http://"),
            !imageURL.hasPrefix("https://")
        else {
            return imageURL
        }

        let base =
            mediaBaseURL.hasSuffix("/")
            ? String(mediaBaseURL.dropLast())
            : mediaBaseURL
        let path =
            imageURL.hasPrefix("/")
            ? imageURL
            : "/\(imageURL)"
        return base + path
    }

    public static func resolveMarkdownImageURLs(
        in source: String,
        mediaBaseURL: String
    ) -> String {
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
            result.replaceSubrange(
                markerRange.lowerBound..<pathEnd,
                with: resolve(path, mediaBaseURL: mediaBaseURL)
            )
            searchStart = result.index(
                result.startIndex,
                offsetBy: result.distance(
                    from: result.startIndex,
                    to: markerRange.lowerBound
                ) + resolve(path, mediaBaseURL: mediaBaseURL).count
            )
        }
        return result
    }
}
