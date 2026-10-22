public import FeatherApplication
public import WebDomain

public import struct Foundation.Date

extension Metadata.Detail {
    public struct Output: DTO {
        public let id: String
        public let referenceType: String
        public let referenceID: String
        public let template: String
        public let slug: String
        public let publicationDate: Date
        public let expirationDate: Date?
        public let status: Metadata.Model.Status
        public let title: String?
        public let excerpt: String?
        public let imageURL: String?
        public let canonicalURL: String?
        public let noIndex: Bool
        public let primaryKeyword: String?
        public let cssCodeInjection: String?
        public let javascriptCodeInjection: String?
        public let structuredDataCodeInjection: String?
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            referenceType: String,
            referenceID: String,
            template: String,
            slug: String,
            publicationDate: Date,
            expirationDate: Date?,
            status: Metadata.Model.Status,
            title: String?,
            excerpt: String?,
            imageURL: String?,
            canonicalURL: String?,
            noIndex: Bool,
            primaryKeyword: String?,
            cssCodeInjection: String?,
            javascriptCodeInjection: String?,
            structuredDataCodeInjection: String?,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.referenceType = referenceType
            self.referenceID = referenceID
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
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}

extension Metadata.Model {
    public var asDetail: Metadata.Detail.Output {
        .init(
            id: id,
            referenceType: reference.type,
            referenceID: reference.id ?? "[!!!INVALID!!!]",
            template: template,
            slug: slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: status,
            title: title,
            excerpt: excerpt,
            imageURL: imageURL,
            canonicalURL: canonicalURL,
            noIndex: noIndex,
            primaryKeyword: primaryKeyword,
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Metadata.Detail.Output {
    public struct Resolved: Sendable {
        public let title: String
        public let excerpt: String
        public let imageURL: String?

        public init(
            metadata: Metadata.Detail.Output,
            fallbackTitle: String,
            fallbackExcerpt: String,
            fallbackImageURL: String?
        ) {
            self.title = Self.resolve(metadata.title, fallback: fallbackTitle)
            self.excerpt = Self.resolve(
                metadata.excerpt,
                fallback: fallbackExcerpt
            )
            self.imageURL = Self.resolveOptional(
                metadata.imageURL,
                fallback: fallbackImageURL
            )
        }

        private static func resolve(_ value: String?, fallback: String)
            -> String
        {
            resolveOptional(value, fallback: fallback) ?? ""
        }

        private static func resolveOptional(
            _ value: String?,
            fallback: String?
        ) -> String? {
            nonEmpty(value) ?? nonEmpty(fallback)
        }

        private static func nonEmpty(_ value: String?) -> String? {
            guard let value else { return nil }
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }
    }

    public func availability(at date: Date) -> Metadata.Model.Availability {
        .init(
            status: status,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            at: date
        )
    }

    public func isPublic(at date: Date) -> Bool {
        status == .published && isWithinPublicationWindow(at: date)
    }

    public func isDirectlyAccessible(at date: Date) -> Bool {
        switch status {
        case .draft:
            true
        case .published:
            isWithinPublicationWindow(at: date)
        case .archived:
            false
        }
    }

    private func isWithinPublicationWindow(at date: Date) -> Bool {
        guard publicationDate <= date else { return false }
        if let expirationDate, expirationDate <= date { return false }
        return true
    }
}
