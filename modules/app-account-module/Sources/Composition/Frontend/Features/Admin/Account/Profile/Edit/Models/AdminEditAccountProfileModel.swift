import FeatherAdmin

struct AdminEditAccountProfileModel: Sendable {
    let id: String
    let firstName: String?
    let lastName: String?
    let profileImageAssetId: String?
    let profileImageAsset: NewAdminMediaAsset?

    var accountProfile: AdminAccountProfileModel {
        .init(
            firstName: firstName,
            lastName: lastName,
            profileImageAssetId: profileImageAssetId,
            profileImageAsset: profileImageAsset
        )
    }
}
