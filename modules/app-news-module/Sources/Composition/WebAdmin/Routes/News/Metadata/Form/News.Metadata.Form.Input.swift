import FeatherWebAdmin
import WebModule
import WebModuleWebAdmin

extension News.Metadata.Form {
    struct Input: Codable, Sendable {
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

        init(
            metadataSlug: String,
            status: String,
            publicationTimestamp: Double,
            expirationTimestamp: Double?,
            title: String?,
            excerpt: String?,
            imageURL: String?,
            canonicalURL: String?,
            noIndex: Bool,
            primaryKeyword: String?,
            cssCodeInjection: String?,
            javascriptCodeInjection: String?,
            structuredDataCodeInjection: String?,
            dateFormatter: AdminDateFormatter
        ) {
            self.init(
                slug: metadataSlug,
                status: status,
                publicationDate: dateFormatter.formatDateTimeInput(
                    unixTimestamp: publicationTimestamp
                ),
                expirationDate: expirationTimestamp.map {
                    dateFormatter.formatDateTimeInput(unixTimestamp: $0)
                } ?? "",
                metaTitle: title ?? "",
                metaExcerpt: excerpt ?? "",
                imageURL: imageURL ?? "",
                canonicalURL: canonicalURL ?? "",
                noIndex: noIndex,
                primaryKeyword: primaryKeyword ?? "",
                cssCodeInjection: cssCodeInjection ?? "",
                javascriptCodeInjection: javascriptCodeInjection ?? "",
                structuredDataCodeInjection: structuredDataCodeInjection ?? ""
            )
        }

        func fields(
            dateFormatter: AdminDateFormatter
        ) -> WebModule.Metadata.Fields.State {
            adminFields(
                template: "news.article",
                dateFormatter: dateFormatter
            )
        }

        func adminFields(
            template: String,
            dateFormatter: AdminDateFormatter
        ) -> WebModule.Metadata.Fields.State {
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
            var state = WebModule.Metadata.FieldStateFactory.make(
                value,
                dateFormatter: dateFormatter
            )
            state.title.key = "metaTitle"
            state.excerpt.key = "metaExcerpt"
            state.imageUrl.key = "imageURL"
            state.canonicalUrl.key = "canonicalURL"
            return state
        }

    }
}
