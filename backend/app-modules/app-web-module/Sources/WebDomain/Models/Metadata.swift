import Domain
import struct Foundation.Date

public struct Metadata: Model {

    public struct Reference: Sendable, Equatable, Hashable {
        public let type: String
        public let id: String

        public init(type: String, id: String) {
            self.type = type
            self.id = id
        }
    }

    public enum Status: String, Sendable, CaseIterable {
        case draft
        case published
        case archived
    }

    public enum Error: DomainError {
        case slugTooShort
        case slugTooLong
        case titleTooLong
        case excerptTooLong
        case imageURLTooLong
        case canonicalURLTooLong
        case primaryKeywordTooLong
        case cssCodeInjectionTooLong
        case javascriptCodeInjectionTooLong
        case structuredDataCodeInjectionTooLong
        case invalidPublicationDateRange
    }

    public struct New: Sendable {
        public let id: String
        public let reference: Reference?
        public let slug: String
        public let publicationDate: Date?
        public let expirationDate: Date?
        public let status: Status
        public let title: String?
        public let excerpt: String?
        public let imageURL: String?
        public let canonicalURL: String
        public let noIndex: Bool
        public let primaryKeyword: String
        public let cssCodeInjection: String
        public let javascriptCodeInjection: String
        public let structuredDataCodeInjection: String
    }

    public let id: String
    public var reference: Reference?
    public var slug: String
    public var publicationDate: Date?
    public var expirationDate: Date?
    public var status: Status
    public var title: String?
    public var excerpt: String?
    public var imageURL: String?
    public var canonicalURL: String
    public var noIndex: Bool
    public var primaryKeyword: String
    public var cssCodeInjection: String
    public var javascriptCodeInjection: String
    public var structuredDataCodeInjection: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        reference: Reference?,
        slug: String,
        publicationDate: Date?,
        expirationDate: Date?,
        status: Status,
        title: String?,
        excerpt: String?,
        imageURL: String?,
        canonicalURL: String,
        noIndex: Bool,
        primaryKeyword: String,
        cssCodeInjection: String,
        javascriptCodeInjection: String,
        structuredDataCodeInjection: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.reference = reference
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

public extension Metadata {

    private static func validate(
        slug: String
    ) throws(Self.Error) {
        guard !slug.isEmpty else {
            throw .slugTooShort
        }
        guard slug.count < 255 else {
            throw .slugTooLong
        }
    }

    private static func validate(
        reference: Reference?
    ) throws(Self.Error) {
        guard let reference else {
            return
        }
        guard !reference.type.isEmpty else {
            throw .slugTooShort
        }
        guard !reference.id.isEmpty else {
            throw .slugTooShort
        }
    }

    private static func validate(
        title: String?
    ) throws(Self.Error) {
        guard let title else {
            return
        }
        guard title.count < 255 else {
            throw .titleTooLong
        }
    }

    private static func validate(
        excerpt: String?
    ) throws(Self.Error) {
        guard let excerpt else {
            return
        }
        guard excerpt.count < 4_000 else {
            throw .excerptTooLong
        }
    }

    private static func validate(
        imageURL: String?
    ) throws(Self.Error) {
        guard let imageURL else {
            return
        }
        guard imageURL.count < 2_048 else {
            throw .imageURLTooLong
        }
    }

    private static func validate(
        canonicalURL: String
    ) throws(Self.Error) {
        guard canonicalURL.count < 2_048 else {
            throw .canonicalURLTooLong
        }
    }

    private static func validate(
        primaryKeyword: String
    ) throws(Self.Error) {
        guard primaryKeyword.count < 255 else {
            throw .primaryKeywordTooLong
        }
    }

    private static func validate(
        cssCodeInjection: String
    ) throws(Self.Error) {
        guard cssCodeInjection.count < 200_000 else {
            throw .cssCodeInjectionTooLong
        }
    }

    private static func validate(
        javascriptCodeInjection: String
    ) throws(Self.Error) {
        guard javascriptCodeInjection.count < 200_000 else {
            throw .javascriptCodeInjectionTooLong
        }
    }

    private static func validate(
        structuredDataCodeInjection: String
    ) throws(Self.Error) {
        guard structuredDataCodeInjection.count < 200_000 else {
            throw .structuredDataCodeInjectionTooLong
        }
    }

    private static func validate(
        publicationDate: Date?,
        expirationDate: Date?
    ) throws(Self.Error) {
        guard
            let publicationDate,
            let expirationDate,
            publicationDate <= expirationDate
        else {
            if publicationDate != nil && expirationDate != nil {
                throw .invalidPublicationDateRange
            }
            return
        }
    }

    static func create(
        id: String,
        reference: Reference? = nil,
        slug: String,
        publicationDate: Date?,
        expirationDate: Date?,
        status: Status,
        title: String?,
        excerpt: String?,
        imageURL: String?,
        canonicalURL: String,
        noIndex: Bool,
        primaryKeyword: String,
        cssCodeInjection: String,
        javascriptCodeInjection: String,
        structuredDataCodeInjection: String
    ) throws(Self.Error) -> Self.New {
        try validate(reference: reference)
        try validate(slug: slug)
        try validate(
            publicationDate: publicationDate,
            expirationDate: expirationDate
        )
        try validate(title: title)
        try validate(excerpt: excerpt)
        try validate(imageURL: imageURL)
        try validate(canonicalURL: canonicalURL)
        try validate(primaryKeyword: primaryKeyword)
        try validate(cssCodeInjection: cssCodeInjection)
        try validate(javascriptCodeInjection: javascriptCodeInjection)
        try validate(structuredDataCodeInjection: structuredDataCodeInjection)

        return .init(
            id: id,
            reference: reference,
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
            structuredDataCodeInjection: structuredDataCodeInjection
        )
    }

    mutating func update(
        reference: Reference?? = nil,
        slug: String? = nil,
        publicationDate: Date?? = nil,
        expirationDate: Date?? = nil,
        status: Status? = nil,
        title: String?? = nil,
        excerpt: String?? = nil,
        imageURL: String?? = nil,
        canonicalURL: String? = nil,
        noIndex: Bool? = nil,
        primaryKeyword: String? = nil,
        cssCodeInjection: String? = nil,
        javascriptCodeInjection: String? = nil,
        structuredDataCodeInjection: String? = nil
    ) throws(Self.Error) {
        let newReference = reference ?? self.reference
        let newSlug = slug ?? self.slug
        let newPublicationDate = publicationDate ?? self.publicationDate
        let newExpirationDate = expirationDate ?? self.expirationDate
        let newStatus = status ?? self.status
        let newTitle = title ?? self.title
        let newExcerpt = excerpt ?? self.excerpt
        let newImageURL = imageURL ?? self.imageURL
        let newCanonicalURL = canonicalURL ?? self.canonicalURL
        let newNoIndex = noIndex ?? self.noIndex
        let newPrimaryKeyword = primaryKeyword ?? self.primaryKeyword
        let newCSSCodeInjection = cssCodeInjection ?? self.cssCodeInjection
        let newJavaScriptCodeInjection =
            javascriptCodeInjection ?? self.javascriptCodeInjection
        let newStructuredDataCodeInjection =
            structuredDataCodeInjection ?? self.structuredDataCodeInjection

        try Self.validate(reference: newReference)
        try Self.validate(slug: newSlug)
        try Self.validate(
            publicationDate: newPublicationDate,
            expirationDate: newExpirationDate
        )
        try Self.validate(title: newTitle)
        try Self.validate(excerpt: newExcerpt)
        try Self.validate(imageURL: newImageURL)
        try Self.validate(canonicalURL: newCanonicalURL)
        try Self.validate(primaryKeyword: newPrimaryKeyword)
        try Self.validate(cssCodeInjection: newCSSCodeInjection)
        try Self.validate(javascriptCodeInjection: newJavaScriptCodeInjection)
        try Self.validate(
            structuredDataCodeInjection: newStructuredDataCodeInjection
        )

        self.reference = newReference
        self.slug = newSlug
        self.publicationDate = newPublicationDate
        self.expirationDate = newExpirationDate
        self.status = newStatus
        self.title = newTitle
        self.excerpt = newExcerpt
        self.imageURL = newImageURL
        self.canonicalURL = newCanonicalURL
        self.noIndex = newNoIndex
        self.primaryKeyword = newPrimaryKeyword
        self.cssCodeInjection = newCSSCodeInjection
        self.javascriptCodeInjection = newJavaScriptCodeInjection
        self.structuredDataCodeInjection = newStructuredDataCodeInjection
    }
}
