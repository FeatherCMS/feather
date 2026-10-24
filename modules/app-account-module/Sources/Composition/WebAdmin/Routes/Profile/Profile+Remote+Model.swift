import AccountModule
import FeatherWebAdmin

extension Profile {
    enum Remote {
        struct Model: Sendable {
            let firstName: String?
            let lastName: String?
            let profileImageAssetId: String?
            let profileImageAsset: AdminMediaAsset?
        }
    }
}
