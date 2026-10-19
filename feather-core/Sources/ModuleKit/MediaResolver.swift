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

        let base =
            mediaBaseURL.absoluteString.hasSuffix("/")
            ? String(mediaBaseURL.absoluteString.dropLast())
            : mediaBaseURL.absoluteString
        let path =
            imagePath.hasPrefix("/")
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
        let markers = ["/originals/", "/variants/"]
        var result = ""
        var searchStart = source.startIndex

        while searchStart < source.endIndex {
            let match =
                markers.compactMap { marker -> Range<String.Index>? in
                    source.range(
                        of: marker,
                        range: searchStart..<source.endIndex
                    )
                }
                .min { $0.lowerBound < $1.lowerBound }
            guard let match else {
                result.append(contentsOf: source[searchStart...])
                break
            }

            var pathStart = match.lowerBound
            while pathStart > searchStart {
                let previous = source.index(before: pathStart)
                let character = source[previous]
                guard
                    character.isLetter || character.isNumber
                        || "_-/.~%+".contains(character)
                else { break }
                pathStart = previous
            }

            let hasPathBoundary: Bool = {
                guard pathStart < source.endIndex,
                    source[pathStart] == "/"
                else { return false }
                guard pathStart > source.startIndex else { return true }
                let previous = source[source.index(before: pathStart)]
                return !previous.isLetter && !previous.isNumber
                    && !"/:._-".contains(previous)
            }()

            guard hasPathBoundary else {
                result.append(
                    contentsOf: source[searchStart..<match.upperBound]
                )
                searchStart = match.upperBound
                continue
            }

            var pathEnd = match.upperBound
            while pathEnd < source.endIndex {
                let character = source[pathEnd]
                guard
                    character.isLetter || character.isNumber
                        || "_-/.~%+".contains(character)
                else { break }
                pathEnd = source.index(after: pathEnd)
            }

            let path = String(source[pathStart..<pathEnd])
            result.append(contentsOf: source[searchStart..<pathStart])
            result.append(contentsOf: resolve(imagePath: path) ?? path)
            searchStart = pathEnd
        }
        return result
    }
}
