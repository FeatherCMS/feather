import FeatherAdmin
import MediaAdminAPI

struct AdminListMediaAssetRepositoryResult: Sendable {
    let items: [Components.Schemas.MediaAssetListItemSchema]
    let pageState: NewAdminListPageState
}
