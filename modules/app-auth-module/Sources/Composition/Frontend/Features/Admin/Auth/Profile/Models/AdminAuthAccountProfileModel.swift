import FeatherAdmin

struct AdminAuthAccountProfileModel: Sendable {
    let firstName: String?
    let lastName: String?
    let profileImageAssetId: String?
    let profileImageAsset: AdminMediaAssetReferenceModel?
}
