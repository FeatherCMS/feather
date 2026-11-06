extension Public.Metadata {
    public struct Model: Sendable {
        public let slug: String
        public let title: String
        public let excerpt: String
        public let imageURL: String
        public let canonicalURL: String?
        public let noIndex: Bool
        public let cssCodeInjection: String?
        public let javascriptCodeInjection: String?
        public let structuredDataCodeInjection: String?
        public let templateData: String?
        public let publicationDateText: String?

        public init(
            slug: String,
            title: String,
            excerpt: String,
            imageURL: String,
            canonicalURL: String?,
            noIndex: Bool,
            cssCodeInjection: String?,
            javascriptCodeInjection: String?,
            structuredDataCodeInjection: String?,
            publicationDateText: String?,
            templateData: String? = nil
        ) {
            self.slug = slug
            self.title = title
            self.excerpt = excerpt
            self.imageURL = imageURL
            self.canonicalURL = canonicalURL
            self.noIndex = noIndex
            self.cssCodeInjection = cssCodeInjection
            self.javascriptCodeInjection = javascriptCodeInjection
            self.structuredDataCodeInjection = structuredDataCodeInjection
            self.templateData = templateData
            self.publicationDateText = publicationDateText
        }

        public func seoTitle(
            fallback: String
        ) -> String {
            title.isEmpty ? fallback : title
        }

        public func seoDescription(
            fallback: String
        ) -> String {
            excerpt.isEmpty ? fallback : excerpt
        }

        public func seoImageURL(
            fallback: String
        ) -> String {
            imageURL.isEmpty ? fallback : imageURL
        }
    }
}
