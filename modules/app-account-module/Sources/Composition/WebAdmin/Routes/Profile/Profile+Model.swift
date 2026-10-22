import FeatherWebAdmin

extension Profile {
    struct Model: Sendable {
        let firstName: String?
        let lastName: String?
        let profileImageAssetId: String?
        let profileImageAsset: AdminMediaAsset?
    }
}
