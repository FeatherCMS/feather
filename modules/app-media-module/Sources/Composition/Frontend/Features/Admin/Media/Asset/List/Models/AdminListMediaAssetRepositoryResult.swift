import FeatherAdmin
import MediaAdminAPI

struct AdminListMediaAssetRepositoryResult: Sendable {
    let items: [Components.Schemas.MediaAssetNodeSearchItemSchema]
    let pageState: NewAdminListPageState
}
