import FeatherContracts
import Foundation
import NewsAdminAPI

struct AdminNewsCategoryFormInput: Codable, Sendable {
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

    init(item: Components.Schemas.NewsCategoryDetailSchema) {
        title = item.title
        excerpt = item.excerpt
        content = item.content
        imageAssetId = item.imageAssetId ?? ""
        let metadata = NewsMetadataFormInput(metadata: item.metadata)
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

    var metadata: NewsMetadataFormInput {
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

    var schema: Components.Schemas.NewsCategoryCreateSchema {
        .init(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            excerpt: excerpt.trimmingCharacters(in: .whitespacesAndNewlines),
            content: content,
            imageAssetId: imageAssetId.emptyToNil,
            metadata: metadata.schema
        )
    }
}
