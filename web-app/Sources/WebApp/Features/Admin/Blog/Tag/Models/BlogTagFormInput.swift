import Foundation

struct BlogTagFormInput: Codable, Sendable, Equatable, Hashable {

    let title: String
    let excerpt: String
    let content: String
    let imageAssetId: String?
    let slug: String
    let publicationDate: String
    let expirationDate: String
    let status: String
    let metadataTitle: String
    let metadataExcerpt: String
    let imageUrl: String
    let canonicalUrl: String
    let noIndex: CheckboxFormInput
    let primaryKeyword: String
    let cssCodeInjection: String
    let javascriptCodeInjection: String
    let structuredDataCodeInjection: String
    let submitAction: String?

    enum CodingKeys: String, CodingKey {
        case title
        case excerpt
        case content
        case imageAssetId
        case slug = "md_slug"
        case publicationDate = "md_publication_date"
        case expirationDate = "md_expiration_date"
        case status = "md_status"
        case metadataTitle = "md_title"
        case metadataExcerpt = "md_excerpt"
        case imageUrl = "md_image_url"
        case canonicalUrl = "md_canonical_url"
        case noIndex = "md_no_index"
        case primaryKeyword = "md_primary_keyword"
        case cssCodeInjection = "md_css"
        case javascriptCodeInjection = "md_js"
        case structuredDataCodeInjection = "md_structured_data"
        case submitAction
    }

    init(
        title: String,
        excerpt: String,
        content: String,
        imageAssetId: String?,
        slug: String,
        publicationDate: String,
        expirationDate: String,
        status: String,
        metadataTitle: String,
        metadataExcerpt: String,
        imageUrl: String,
        canonicalUrl: String,
        noIndex: CheckboxFormInput,
        primaryKeyword: String,
        cssCodeInjection: String,
        javascriptCodeInjection: String,
        structuredDataCodeInjection: String,
        submitAction: String?
    ) {
        self.title = title
        self.excerpt = excerpt
        self.content = content
        self.imageAssetId = imageAssetId
        self.slug = slug
        self.publicationDate = publicationDate
        self.expirationDate = expirationDate
        self.status = status
        self.metadataTitle = metadataTitle
        self.metadataExcerpt = metadataExcerpt
        self.imageUrl = imageUrl
        self.canonicalUrl = canonicalUrl
        self.noIndex = noIndex
        self.primaryKeyword = primaryKeyword
        self.cssCodeInjection = cssCodeInjection
        self.javascriptCodeInjection = javascriptCodeInjection
        self.structuredDataCodeInjection = structuredDataCodeInjection
        self.submitAction = submitAction
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.excerpt = try container.decode(String.self, forKey: .excerpt)
        self.content = try container.decode(String.self, forKey: .content)
        self.imageAssetId = try container.decodeIfPresent(
            String.self,
            forKey: .imageAssetId
        )
        self.slug = try container.decode(String.self, forKey: .slug)
        self.publicationDate = try container.decode(
            String.self,
            forKey: .publicationDate
        )
        self.expirationDate = try container.decode(
            String.self,
            forKey: .expirationDate
        )
        self.status = try container.decode(String.self, forKey: .status)
        self.metadataTitle = try container.decode(
            String.self,
            forKey: .metadataTitle
        )
        self.metadataExcerpt = try container.decode(
            String.self,
            forKey: .metadataExcerpt
        )
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.canonicalUrl = try container.decode(
            String.self,
            forKey: .canonicalUrl
        )
        self.noIndex =
            try container.decodeIfPresent(
                CheckboxFormInput.self,
                forKey: .noIndex
            )
            ?? .init(value: false)
        self.primaryKeyword = try container.decode(
            String.self,
            forKey: .primaryKeyword
        )
        self.cssCodeInjection = try container.decode(
            String.self,
            forKey: .cssCodeInjection
        )
        self.javascriptCodeInjection = try container.decode(
            String.self,
            forKey: .javascriptCodeInjection
        )
        self.structuredDataCodeInjection = try container.decode(
            String.self,
            forKey: .structuredDataCodeInjection
        )
        self.submitAction = try container.decodeIfPresent(
            String.self,
            forKey: .submitAction
        )
    }

    var normalizedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedContent: String {
        content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedExcerpt: String {
        excerpt.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedMetadataTitle: String {
        metadataTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var effectiveStatus: String {
        if submitAction == "publish" {
            return "published"
        }
        return status
    }

    var normalizedImageAssetId: String? {
        imageAssetId?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .nilIfEmpty
    }

    var metadataValue: AdminMetadataFormValue {
        .init(
            slug: slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: effectiveStatus,
            title: normalizedMetadataTitle,
            excerpt: metadataExcerpt,
            imageUrl: imageUrl,
            canonicalUrl: canonicalUrl,
            noIndex: noIndex.value,
            primaryKeyword: primaryKeyword,
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection
        )
    }

    func withStatus(
        _ status: String
    ) -> Self {
        .init(
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            slug: slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: status,
            metadataTitle: metadataTitle,
            metadataExcerpt: metadataExcerpt,
            imageUrl: imageUrl,
            canonicalUrl: canonicalUrl,
            noIndex: noIndex,
            primaryKeyword: primaryKeyword,
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection,
            submitAction: nil
        )
    }
}
