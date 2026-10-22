import FeatherWebAdmin

struct AdminAccountProfileModel: Sendable {
    let firstName: String?
    let lastName: String?
    let profileImageAssetId: String?
    let profileImageAsset: AdminMediaAsset?
}
