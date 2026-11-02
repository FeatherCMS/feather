import Foundation

public struct Slug: Sendable {
    public struct Segment: Sendable {
        public let source: String
        public let value: String

        public init(
            normalizing source: String
        ) {
            var value = ""
            var needsSeparator = false

            for scalar in source.folding(
                options: .diacriticInsensitive,
                locale: .current
            )
            .lowercased()
            .unicodeScalars {
                let isLowercaseLetter = scalar.value >= 97 && scalar.value <= 122
                let isNumber = scalar.value >= 48 && scalar.value <= 57

                if isLowercaseLetter || isNumber {
                    if needsSeparator, !value.isEmpty {
                        value.append("-")
                    }
                    value.append(String(scalar))
                    needsSeparator = false
                }
                else if !value.isEmpty {
                    needsSeparator = true
                }
            }

            self.source = source
            self.value = value
        }
    }

    public let source: String
    public let components: [Segment]
    public let separator: Character

    public var path: String {
        components.map(\.value).joined(separator: String(separator))
    }

    public var lastSegment: Segment? {
        components.last
    }

    public var parent: Self? {
        guard components.count > 1 else {
            return nil
        }

        let parentComponents = Array(components.dropLast())
        let source = parentComponents
            .map(\.source)
            .joined(separator: String(separator))

        return .init(
            source: source,
            components: parentComponents,
            separator: separator
        )
    }

    public init(
        parsing source: String,
        separator: Character = "/"
    ) {
        let components = source
            .split(separator: separator)
            .map { Segment(normalizing: String($0)) }
            .filter { !$0.value.isEmpty }

        self.source = source
        self.components = components
        self.separator = separator
    }

    public func appending(
        _ source: String
    ) -> Self {
        let segment = Segment(normalizing: source)
        var components = self.components
        if !segment.value.isEmpty {
            components.append(segment)
        }

        let combinedSource: String
        if self.source.isEmpty {
            combinedSource = source
        }
        else if source.isEmpty {
            combinedSource = self.source
        }
        else {
            combinedSource = self.source + String(separator) + source
        }

        return .init(
            source: combinedSource,
            components: components,
            separator: separator
        )
    }

    private init(
        source: String,
        components: [Segment],
        separator: Character
    ) {
        self.source = source
        self.components = components
        self.separator = separator
    }
}
