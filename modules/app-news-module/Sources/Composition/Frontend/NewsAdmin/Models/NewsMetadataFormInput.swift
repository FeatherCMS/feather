import FeatherAdmin
import FeatherContracts
import Foundation
import NewsAdminAPI
import WebFrontend

struct NewsMetadataFormInput: Codable, Sendable {
    var slug: String
    var status: String
    var publicationDate: String
    var expirationDate: String
    var metaTitle: String
    var metaExcerpt: String
    var imageURL: String
    var canonicalURL: String
    var noIndex: Bool?
    var primaryKeyword: String
    var cssCodeInjection: String
    var javascriptCodeInjection: String
    var structuredDataCodeInjection: String

    init(
        slug: String = "",
        status: String = "draft",
        publicationDate: String = "",
        expirationDate: String = "",
        metaTitle: String = "",
        metaExcerpt: String = "",
        imageURL: String = "",
        canonicalURL: String = "",
        noIndex: Bool? = false,
        primaryKeyword: String = "",
        cssCodeInjection: String = "",
        javascriptCodeInjection: String = "",
        structuredDataCodeInjection: String = ""
    ) {
        self.slug = slug
        self.status = status
        self.publicationDate = publicationDate
        self.expirationDate = expirationDate
        self.metaTitle = metaTitle
        self.metaExcerpt = metaExcerpt
        self.imageURL = imageURL
        self.canonicalURL = canonicalURL
        self.noIndex = noIndex
        self.primaryKeyword = primaryKeyword
        self.cssCodeInjection = cssCodeInjection
        self.javascriptCodeInjection = javascriptCodeInjection
        self.structuredDataCodeInjection = structuredDataCodeInjection
    }

    init(metadata: Components.Schemas.NewsMetadataDetailSchema) {
        self.init(
            slug: metadata.slug,
            status: metadata.status,
            publicationDate: Self.formatDate(metadata.publicationDate),
            expirationDate: metadata.expirationDate.map(Self.formatDate) ?? "",
            metaTitle: metadata.title ?? "",
            metaExcerpt: metadata.excerpt ?? "",
            imageURL: metadata.imageURL ?? "",
            canonicalURL: metadata.canonicalURL ?? "",
            noIndex: metadata.noIndex,
            primaryKeyword: metadata.primaryKeyword ?? "",
            cssCodeInjection: metadata.cssCodeInjection ?? "",
            javascriptCodeInjection: metadata.javascriptCodeInjection ?? "",
            structuredDataCodeInjection:
                metadata.structuredDataCodeInjection ?? ""
        )
    }

    var fields: AdminMetadataFields.State {
        adminFields(template: "news.article")
    }

    func adminFields(
        template: String
    ) -> AdminMetadataFields.State {
        let value = AdminMetadataFormValue(
            slug: slug,
            template: template,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: status,
            title: metaTitle,
            excerpt: metaExcerpt,
            imageUrl: imageURL,
            canonicalUrl: canonicalURL,
            noIndex: noIndex ?? false,
            primaryKeyword: primaryKeyword,
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection
        )
        var state = AdminMetadataFieldStateFactory.make(value)
        state.title.key = "metaTitle"
        state.excerpt.key = "metaExcerpt"
        state.imageUrl.key = "imageURL"
        state.canonicalUrl.key = "canonicalURL"
        return state
    }

    var schema: Components.Schemas.NewsMetadataInputSchema {
        .init(
            slug: slug.trimmingCharacters(in: .whitespacesAndNewlines),
            status: status,
            publicationDate: AdminMetadataSchemaBuilder.parseTimestamp(
                publicationDate
            ),
            expirationDate: AdminMetadataSchemaBuilder.parseTimestamp(
                expirationDate
            ),
            title: metaTitle.emptyToNil,
            excerpt: metaExcerpt.emptyToNil,
            imageURL: imageURL.emptyToNil,
            canonicalURL: canonicalURL.emptyToNil,
            noIndex: noIndex ?? false,
            primaryKeyword: primaryKeyword.emptyToNil,
            cssCodeInjection: cssCodeInjection.emptyToNil,
            javascriptCodeInjection: javascriptCodeInjection.emptyToNil,
            structuredDataCodeInjection:
                structuredDataCodeInjection.emptyToNil
        )
    }

    private static func formatDate(
        _ timestamp: Double
    ) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
