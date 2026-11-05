public import FeatherApplication
public import FeatherDomain
public import WebDomain
public import WebModule

public import struct Foundation.Date

extension Metadata.Edit {
    public struct Input: DTO {
        public let id: String
        public let template: FieldChange<String>
        public let slug: FieldChange<String>
        public let publicationDate: FieldChange<Date>
        public let expirationDate: OptionalFieldChange<Date>
        public let status: FieldChange<Metadata.Model.Status>
        public let title: OptionalFieldChange<String>
        public let excerpt: OptionalFieldChange<String>
        public let imageURL: OptionalFieldChange<String>
        public let canonicalURL: OptionalFieldChange<String>
        public let noIndex: FieldChange<Bool>
        public let primaryKeyword: OptionalFieldChange<String>
        public let cssCodeInjection: OptionalFieldChange<String>
        public let javascriptCodeInjection: OptionalFieldChange<String>
        public let structuredDataCodeInjection: OptionalFieldChange<String>
        public let templateData: OptionalFieldChange<String>

        public init(
            id: String,
            template: FieldChange<String> = .unchanged,
            slug: FieldChange<String> = .unchanged,
            publicationDate: FieldChange<Date> = .unchanged,
            expirationDate: OptionalFieldChange<Date> = .unchanged,
            status: FieldChange<Metadata.Model.Status> = .unchanged,
            title: OptionalFieldChange<String> = .unchanged,
            excerpt: OptionalFieldChange<String> = .unchanged,
            imageURL: OptionalFieldChange<String> = .unchanged,
            canonicalURL: OptionalFieldChange<String> = .unchanged,
            noIndex: FieldChange<Bool> = .unchanged,
            primaryKeyword: OptionalFieldChange<String> = .unchanged,
            cssCodeInjection: OptionalFieldChange<String> = .unchanged,
            javascriptCodeInjection: OptionalFieldChange<String> = .unchanged,
            structuredDataCodeInjection: OptionalFieldChange<String> =
                .unchanged,
            templateData: OptionalFieldChange<String> = .unchanged
        ) {
            self.id = id
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
            self.templateData = templateData
        }
    }
}
