import AdminOpenAPI
import Foundation

struct BlogAuthorDetailsModel: Sendable {
    let id: String
    let name: String
    let excerpt: String
    let content: String
    let profileImageAssetId: String?
    let profileImage: AdminMediaAssetReferenceModel?
    let metadata: AdminMetadataFormValue
    let items: [Components.Schemas.BlogAuthorLinkListItemSchema]
}
