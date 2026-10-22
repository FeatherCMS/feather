import AccountModule
import FeatherWebAdmin

extension Profile.Edit {

    struct Model: Sendable {
        let id: String
        let firstName: String?
        let lastName: String?
        let profileImageAssetId: String?
        let profileImageAsset: AdminMediaAsset?

        var profile: Profile.Model {
            .init(
                firstName: firstName,
                lastName: lastName,
                profileImageAssetId: profileImageAssetId,
                profileImageAsset: profileImageAsset
            )
        }
    }
}
