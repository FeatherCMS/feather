import FeatherWebAdmin
import MediaAdminAPI
import MediaModule

extension Asset.File.List.Repository {
    struct Result: Sendable {
        let items: [Components.Schemas.MediaAssetNodeQueryItemSchema]
        let pageState: AdminListPageState
    }
}
