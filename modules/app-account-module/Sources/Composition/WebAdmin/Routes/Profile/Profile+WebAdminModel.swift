import AccountModule
import FeatherWebAdmin

extension Profile {
    struct WebAdminModel: Sendable {
        let firstName: String?
        let lastName: String?
        let profileImageAssetId: String?
        let profileImageAsset: AdminMediaAsset?
    }
}
