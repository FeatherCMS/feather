import AdminOpenAPI
import Foundation

struct AdminMetadataSchemaBuilder {
    static func createSchema(
        input: AdminMetadataFormValue
    ) -> Components.Schemas.WebMetadataCreateSchema {
        .init(
            slug: input.normalizedSlug,
            publicationDate: parseDate(input.normalizedPublicationDate),
            expirationDate: parseDate(input.normalizedExpirationDate),
            status: input.normalizedStatus,
            title: emptyToNil(input.normalizedTitle),
            excerpt: emptyToNil(input.normalizedExcerpt),
            imageUrl: emptyToNil(input.normalizedImageUrl),
            canonicalUrl: emptyToNil(input.normalizedCanonicalUrl),
            noIndex: input.noIndex,
            primaryKeyword: emptyToNil(input.normalizedPrimaryKeyword),
            cssCodeInjection: emptyToNil(input.normalizedCSSCodeInjection),
            javascriptCodeInjection: emptyToNil(
                input.normalizedJavaScriptCodeInjection
            ),
            structuredDataCodeInjection: emptyToNil(
                input.normalizedStructuredDataCodeInjection
            )
        )
    }

    static func formValue(
        from detail: Components.Schemas.WebMetadataDetailSchema
    ) -> AdminMetadataFormValue {
        .init(
            slug: detail.slug,
            publicationDate: formatDate(detail.publicationDate),
            expirationDate: formatDate(detail.expirationDate),
            status: detail.status,
            title: detail.title ?? "",
            excerpt: detail.excerpt ?? "",
            imageUrl: detail.imageUrl ?? "",
            canonicalUrl: detail.canonicalUrl ?? "",
            noIndex: detail.noIndex,
            primaryKeyword: detail.primaryKeyword,
            cssCodeInjection: detail.cssCodeInjection ?? "",
            javascriptCodeInjection: detail.javascriptCodeInjection ?? "",
            structuredDataCodeInjection: detail.structuredDataCodeInjection
                ?? ""
        )
    }

    static func formValue(
        from detail: Components.Schemas.WebMetadataDetailSchema,
        fallbackTitle: String,
        fallbackExcerpt: String
    ) -> AdminMetadataFormValue {
        let value = formValue(from: detail)
        return .init(
            slug: value.slug,
            publicationDate: value.publicationDate,
            expirationDate: value.expirationDate,
            status: value.status,
            title: normalizeOverride(
                value.title,
                fallback: fallbackTitle
            ),
            excerpt: normalizeOverride(
                value.excerpt,
                fallback: fallbackExcerpt
            ),
            imageUrl: value.imageUrl,
            canonicalUrl: value.canonicalUrl,
            noIndex: value.noIndex,
            primaryKeyword: value.primaryKeyword,
            cssCodeInjection: value.cssCodeInjection,
            javascriptCodeInjection: value.javascriptCodeInjection,
            structuredDataCodeInjection: value.structuredDataCodeInjection
        )
    }

    static func parseTimestamp(
        _ value: String
    ) -> Double? {
        parseDate(value.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    private static func parseDate(
        _ value: String
    ) -> Double? {
        guard !value.isEmpty else {
            return nil
        }
        if let date = makeDateTimeFormatter().date(from: value) {
            return date.timeIntervalSince1970
        }
        if let date = makeDateOnlyFormatter().date(from: value) {
            return date.timeIntervalSince1970
        }
        return ISO8601DateFormatter().date(from: value)?.timeIntervalSince1970
    }

    private static func formatDate(
        _ timestamp: Double?
    ) -> String {
        guard let timestamp else {
            return ""
        }
        return makeDateTimeFormatter()
            .string(
                from: Date(timeIntervalSince1970: timestamp)
            )
    }

    private static func emptyToNil(
        _ value: String
    ) -> String? {
        value.isEmpty ? nil : value
    }

    private static func normalizeOverride(
        _ value: String,
        fallback: String
    ) -> String {
        let normalizedValue = value.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let normalizedFallback = fallback.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard normalizedValue == normalizedFallback else {
            return value
        }
        return ""
    }

    private static func makeDateOnlyFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    private static func makeDateTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter
    }
}
