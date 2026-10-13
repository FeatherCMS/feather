import FeatherAdmin

struct AdminAccountProfileModel: Sendable {
    let firstName: String?
    let lastName: String?
    let profileImageAssetId: String?
    let profileImageAsset: NewAdminMediaAsset?
}
