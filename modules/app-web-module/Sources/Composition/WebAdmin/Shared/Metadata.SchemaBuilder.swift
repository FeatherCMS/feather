public import FeatherWebShared
import FeatherDomain
import FeatherModuleKit
public import FeatherWebAdmin
import OpenAPIRuntime
public import WebAdminAPI
public import WebModule

extension WebModule.Metadata {
    public struct SchemaBuilder {
        public static func createSchema(
            input: AdminMetadataFormValue,
            dateFormatter: AdminDateFormatter
        ) -> Components.Schemas.MetadataCreateSchema {
            .init(
                slug: input.normalizedSlug,
                template: input.normalizedTemplate,
                publicationDate: dateFormatter.unixTimestamp(
                    fromInput: input.normalizedPublicationDate
                ),
                expirationDate: dateFormatter.unixTimestamp(
                    fromInput: input.normalizedExpirationDate
                ),
                status: input.normalizedStatus,
                title: input.normalizedTitle.emptyToNil,
                excerpt: input.normalizedExcerpt.emptyToNil,
                imageUrl: input.normalizedImageUrl.emptyToNil,
                canonicalUrl: input.normalizedCanonicalUrl.emptyToNil,
                noIndex: input.noIndex,
                primaryKeyword: input.normalizedPrimaryKeyword.emptyToNil,
                cssCodeInjection: input.normalizedCSSCodeInjection.emptyToNil,
                javascriptCodeInjection:
                    input.normalizedJavaScriptCodeInjection.emptyToNil,
                structuredDataCodeInjection:
                    input.normalizedStructuredDataCodeInjection.emptyToNil
            )
        }

        public static func formValue<Detail: DetailSchema>(
            from detail: Detail,
            dateFormatter: AdminDateFormatter
        ) -> AdminMetadataFormValue {
            .init(
                slug: detail.slug,
                template: detail.template,
                publicationDate: detail.publicationDate.map {
                    dateFormatter.formatDateTimeInput(unixTimestamp: $0)
                } ?? "",
                expirationDate: detail.expirationDate.map {
                    dateFormatter.formatDateTimeInput(unixTimestamp: $0)
                } ?? "",
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

        public static func formValue<Detail: DetailSchema>(
            from detail: Detail,
            fallbackTitle: String,
            fallbackExcerpt: String,
            dateFormatter: AdminDateFormatter
        ) -> AdminMetadataFormValue {
            let value = formValue(
                from: detail,
                dateFormatter: dateFormatter
            )
            return .init(
                slug: value.slug,
                template: value.template,
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

        public static func parseTimestamp(
            _ value: String,
            dateFormatter: AdminDateFormatter
        ) -> Double? {
            dateFormatter.unixTimestamp(fromInput: value.whitespaceTrimmed)
        }

        private static func normalizeOverride(
            _ value: String,
            fallback: String
        ) -> String {
            let normalizedValue = value.whitespaceTrimmed
            let normalizedFallback = fallback.whitespaceTrimmed
            guard normalizedValue == normalizedFallback else {
                return value
            }
            return ""
        }

    }
}
