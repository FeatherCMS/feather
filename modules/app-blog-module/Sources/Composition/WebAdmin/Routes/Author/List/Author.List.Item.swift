import BlogModule
import FeatherWebAdmin

extension Author.List {
    struct Item: Sendable {
        let id: String
        let name: String
        let profileImageAssetId: String?
        let profileImage: AdminMediaAsset?
        let metadata: AdminMetadataFormValue
    }
}
