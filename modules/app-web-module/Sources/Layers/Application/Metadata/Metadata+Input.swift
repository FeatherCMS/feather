import FeatherDomain
import FeatherModuleKit
public import WebDomain
public import WebModule

public import struct Foundation.Date

extension Metadata {
    public struct Input: Sendable, Equatable {
        public let template: String
        public let slug: String
        public let publicationDate: Date?
        public let expirationDate: Date?
        public let status: Model.Status
        public let title: String?
        public let excerpt: String?
        public let imageURL: String?
        public let canonicalURL: String?
        public let noIndex: Bool
        public let primaryKeyword: String
        public let cssCodeInjection: String?
        public let javascriptCodeInjection: String?
        public let structuredDataCodeInjection: String?

        public init(
            slug: String,
            template: String = "default",
            publicationDate: Date?,
            expirationDate: Date?,
            status: Model.Status,
            title: String?,
            excerpt: String?,
            imageURL: String?,
            canonicalURL: String?,
            noIndex: Bool,
            primaryKeyword: String,
            cssCodeInjection: String?,
            javascriptCodeInjection: String?,
            structuredDataCodeInjection: String?
        ) {
            self.template = template
            self.slug = slug
            self.publicationDate = publicationDate
            self.expirationDate = expirationDate
            self.status = status
            self.title = title
            self.excerpt = excerpt
            self.imageURL = imageURL
            self.canonicalURL = canonicalURL
            self.noIndex = noIndex
            self.primaryKeyword = primaryKeyword
            self.cssCodeInjection = cssCodeInjection
            self.javascriptCodeInjection = javascriptCodeInjection
            self.structuredDataCodeInjection = structuredDataCodeInjection
        }

        public func asMetadataBase(
            template: String? = nil,
            slug: String? = nil
        ) -> Model.Base {
            .init(
                template: template ?? self.template,
                slug: slug ?? self.slug,
                publicationDate: publicationDate ?? .init(),
                expirationDate: expirationDate,
                status: status,
                title: title,
                excerpt: excerpt,
                imageURL: imageURL,
                canonicalURL: canonicalURL,
                noIndex: noIndex,
                primaryKeyword: primaryKeyword.emptyToNil,
                cssCodeInjection: cssCodeInjection,
                javascriptCodeInjection: javascriptCodeInjection,
                structuredDataCodeInjection: structuredDataCodeInjection
            )
        }

        public func update(
            _ metadata: inout Metadata.Model,
            template: String? = nil
        ) throws {
            try metadata.update(
                template: template.map(FieldChange.set) ?? .unchanged,
                slug: .set(slug),
                publicationDate: publicationDate.map(FieldChange.set)
                    ?? .unchanged,
                expirationDate: .init(
                    value: expirationDate,
                    shouldApply: expirationDate != nil
                ),
                status: .set(status),
                title: .init(value: title, shouldApply: title != nil),
                excerpt: .init(value: excerpt, shouldApply: excerpt != nil),
                imageURL: .init(value: imageURL, shouldApply: imageURL != nil),
                canonicalURL: .init(
                    value: canonicalURL,
                    shouldApply: canonicalURL != nil
                ),
                noIndex: .set(noIndex),
                primaryKeyword: .init(
                    value: primaryKeyword,
                    shouldApply: true
                ),
                cssCodeInjection: .init(
                    value: cssCodeInjection,
                    shouldApply: cssCodeInjection != nil
                ),
                javascriptCodeInjection: .init(
                    value: javascriptCodeInjection,
                    shouldApply: javascriptCodeInjection != nil
                ),
                structuredDataCodeInjection: .init(
                    value: structuredDataCodeInjection,
                    shouldApply: structuredDataCodeInjection != nil
                )
            )
        }
    }
}
