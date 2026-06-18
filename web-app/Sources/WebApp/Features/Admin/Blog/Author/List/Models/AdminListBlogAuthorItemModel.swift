import Foundation

struct AdminListBlogAuthorItemModel: Sendable {
    let id: String
    let name: String
    let profileImageAssetId: String?
    let profileImage: AdminMediaAssetReferenceModel?
    let metadata: AdminMetadataFormValue
}
