import Application
import Foundation

public struct ResolvedMetadata: DTO {
    public let title: String
    public let excerpt: String
    public let imageURL: String?

    public init(
        metadata: MetadataDetail,
        fallbackTitle: String,
        fallbackExcerpt: String,
        fallbackImageURL: String?
    ) {
        self.title = Self.resolve(
            metadata.title,
            fallback: fallbackTitle
        )
        self.excerpt = Self.resolve(
            metadata.excerpt,
            fallback: fallbackExcerpt
        )
        self.imageURL = Self.resolveOptional(
            metadata.imageURL,
            fallback: fallbackImageURL
        )
    }
}

extension ResolvedMetadata {
    private static func resolve(
        _ value: String?,
        fallback: String
    ) -> String {
        resolveOptional(value, fallback: fallback) ?? ""
    }

    private static func resolveOptional(
        _ value: String?,
        fallback: String?
    ) -> String? {
        nonEmpty(value) ?? nonEmpty(fallback)
    }

    private static func nonEmpty(
        _ value: String?
    ) -> String? {
        guard let value else {
            return nil
        }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
