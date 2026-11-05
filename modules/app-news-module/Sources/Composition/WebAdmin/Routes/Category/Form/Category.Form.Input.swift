import Foundation
import NewsApplication
import NewsModule

extension NewsModule.Category {
    enum Form {}
}

extension NewsModule.Category.Form {
    struct Input: Codable, Sendable {
        var title = ""
        var excerpt = ""
        var content = ""
        var imageAssetId = ""
        var slug = ""
        var status = "draft"
        var publicationDate = ""
        var expirationDate = ""
        var metaTitle = ""
        var metaExcerpt = ""
        var imageURL = ""
        var canonicalURL = ""
        var noIndex: Bool?
        var primaryKeyword = ""
        var cssCodeInjection = ""
        var javascriptCodeInjection = ""
        var structuredDataCodeInjection = ""

        init() {}

        init(item: NewsModule.Category.Detail.Model) {
            title = item.title
            excerpt = item.excerpt
            content = item.content
            imageAssetId = item.imageAssetId ?? ""
            let metadata = item.metadata
            slug = metadata.slug
            status = metadata.status
            publicationDate = metadata.publicationDate
            expirationDate = metadata.expirationDate
            metaTitle = metadata.metaTitle
            metaExcerpt = metadata.metaExcerpt
            imageURL = metadata.imageURL
            canonicalURL = metadata.canonicalURL
            noIndex = metadata.noIndex
            primaryKeyword = metadata.primaryKeyword
            cssCodeInjection = metadata.cssCodeInjection
            javascriptCodeInjection = metadata.javascriptCodeInjection
            structuredDataCodeInjection = metadata.structuredDataCodeInjection
        }

        var metadata: News.Metadata.Form.Input {
            .init(
                slug: slug,
                status: status,
                publicationDate: publicationDate,
                expirationDate: expirationDate,
                metaTitle: metaTitle,
                metaExcerpt: metaExcerpt,
                imageURL: imageURL,
                canonicalURL: canonicalURL,
                noIndex: noIndex,
                primaryKeyword: primaryKeyword,
                cssCodeInjection: cssCodeInjection,
                javascriptCodeInjection: javascriptCodeInjection,
                structuredDataCodeInjection: structuredDataCodeInjection
            )
        }

        var validationMessage: String? {
            if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "Title is required."
            }
            if excerpt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "Excerpt is required."
            }
            if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "Content is required."
            }
            if slug.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return "Slug is required."
            }
            return nil
        }

    }
}
