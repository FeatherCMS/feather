import Foundation

struct BlogAuthorFormInput: Codable, Sendable, Equatable, Hashable {

    let name: String
    let excerpt: String
    let content: String
    let profileImageAssetId: String?
    let metadataSlug: String
    let metadataPublicationDate: String
    let metadataExpirationDate: String
    let metadataStatus: String
    let metadataTitle: String
    let metadataExcerpt: String
    let metadataImageUrl: String
    let metadataCanonicalUrl: String
    let metadataNoIndex: CheckboxFormInput
    let metadataPrimaryKeyword: String
    let metadataCSSCodeInjection: String
    let metadataJavaScriptCodeInjection: String
    let metadataStructuredDataCodeInjection: String
    let submitAction: String?

    enum CodingKeys: String, CodingKey {
        case name
        case excerpt
        case content
        case profileImageAssetId
        case metadataSlug = "md_slug"
        case metadataPublicationDate = "md_publication_date"
        case metadataExpirationDate = "md_expiration_date"
        case metadataStatus = "md_status"
        case metadataTitle = "md_title"
        case metadataExcerpt = "md_excerpt"
        case metadataImageUrl = "md_image_url"
        case metadataCanonicalUrl = "md_canonical_url"
        case metadataNoIndex = "md_no_index"
        case metadataPrimaryKeyword = "md_primary_keyword"
        case metadataCSSCodeInjection = "md_css"
        case metadataJavaScriptCodeInjection = "md_js"
        case metadataStructuredDataCodeInjection = "md_structured_data"
        case submitAction
    }

    init(
        name: String,
        excerpt: String,
        content: String,
        profileImageAssetId: String?,
        metadataSlug: String,
        metadataPublicationDate: String,
        metadataExpirationDate: String,
        metadataStatus: String,
        metadataTitle: String,
        metadataExcerpt: String,
        metadataImageUrl: String,
        metadataCanonicalUrl: String,
        metadataNoIndex: CheckboxFormInput,
        metadataPrimaryKeyword: String,
        metadataCSSCodeInjection: String,
        metadataJavaScriptCodeInjection: String,
        metadataStructuredDataCodeInjection: String,
        submitAction: String?
    ) {
        self.name = name
        self.excerpt = excerpt
        self.content = content
        self.profileImageAssetId = profileImageAssetId
        self.metadataSlug = metadataSlug
        self.metadataPublicationDate = metadataPublicationDate
        self.metadataExpirationDate = metadataExpirationDate
        self.metadataStatus = metadataStatus
        self.metadataTitle = metadataTitle
        self.metadataExcerpt = metadataExcerpt
        self.metadataImageUrl = metadataImageUrl
        self.metadataCanonicalUrl = metadataCanonicalUrl
        self.metadataNoIndex = metadataNoIndex
        self.metadataPrimaryKeyword = metadataPrimaryKeyword
        self.metadataCSSCodeInjection = metadataCSSCodeInjection
        self.metadataJavaScriptCodeInjection = metadataJavaScriptCodeInjection
        self.metadataStructuredDataCodeInjection =
            metadataStructuredDataCodeInjection
        self.submitAction = submitAction
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.excerpt = try container.decode(String.self, forKey: .excerpt)
        self.content = try container.decode(String.self, forKey: .content)
        self.profileImageAssetId = try container.decodeIfPresent(
            String.self,
            forKey: .profileImageAssetId
        )
        self.metadataSlug = try container.decode(
            String.self,
            forKey: .metadataSlug
        )
        self.metadataPublicationDate = try container.decode(
            String.self,
            forKey: .metadataPublicationDate
        )
        self.metadataExpirationDate = try container.decode(
            String.self,
            forKey: .metadataExpirationDate
        )
        self.metadataStatus = try container.decode(
            String.self,
            forKey: .metadataStatus
        )
        self.metadataTitle = try container.decode(
            String.self,
            forKey: .metadataTitle
        )
        self.metadataExcerpt = try container.decode(
            String.self,
            forKey: .metadataExcerpt
        )
        self.metadataImageUrl = try container.decode(
            String.self,
            forKey: .metadataImageUrl
        )
        self.metadataCanonicalUrl = try container.decode(
            String.self,
            forKey: .metadataCanonicalUrl
        )
        self.metadataNoIndex =
            try container.decodeIfPresent(
                CheckboxFormInput.self,
                forKey: .metadataNoIndex
            ) ?? .init(value: false)
        self.metadataPrimaryKeyword = try container.decode(
            String.self,
            forKey: .metadataPrimaryKeyword
        )
        self.metadataCSSCodeInjection = try container.decode(
            String.self,
            forKey: .metadataCSSCodeInjection
        )
        self.metadataJavaScriptCodeInjection = try container.decode(
            String.self,
            forKey: .metadataJavaScriptCodeInjection
        )
        self.metadataStructuredDataCodeInjection = try container.decode(
            String.self,
            forKey: .metadataStructuredDataCodeInjection
        )
        self.submitAction = try container.decodeIfPresent(
            String.self,
            forKey: .submitAction
        )
    }

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedContent: String {
        content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedExcerpt: String {
        excerpt.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedProfileImageAssetId: String? {
        profileImageAssetId?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .nilIfEmpty
    }

    var effectiveMetadataStatus: String {
        if submitAction == "publish" {
            return "published"
        }
        return metadataStatus
    }

    var metadataValue: AdminMetadataFormValue {
        .init(
            slug: metadataSlug,
            publicationDate: metadataPublicationDate,
            expirationDate: metadataExpirationDate,
            status: effectiveMetadataStatus,
            title: metadataTitle,
            excerpt: metadataExcerpt,
            imageUrl: metadataImageUrl,
            canonicalUrl: metadataCanonicalUrl,
            noIndex: metadataNoIndex.value,
            primaryKeyword: metadataPrimaryKeyword,
            cssCodeInjection: metadataCSSCodeInjection,
            javascriptCodeInjection: metadataJavaScriptCodeInjection,
            structuredDataCodeInjection: metadataStructuredDataCodeInjection
        )
    }

    func withStatus(
        _ status: String
    ) -> Self {
        .init(
            name: name,
            excerpt: excerpt,
            content: content,
            profileImageAssetId: profileImageAssetId,
            metadataSlug: metadataSlug,
            metadataPublicationDate: metadataPublicationDate,
            metadataExpirationDate: metadataExpirationDate,
            metadataStatus: status,
            metadataTitle: metadataTitle,
            metadataExcerpt: metadataExcerpt,
            metadataImageUrl: metadataImageUrl,
            metadataCanonicalUrl: metadataCanonicalUrl,
            metadataNoIndex: metadataNoIndex,
            metadataPrimaryKeyword: metadataPrimaryKeyword,
            metadataCSSCodeInjection: metadataCSSCodeInjection,
            metadataJavaScriptCodeInjection: metadataJavaScriptCodeInjection,
            metadataStructuredDataCodeInjection:
                metadataStructuredDataCodeInjection,
            submitAction: nil
        )
    }
}
