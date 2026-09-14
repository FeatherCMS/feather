import FeatherAdmin
import MediaAdminAPI

struct AdminListMediaProcessorRepositoryResult: Sendable {
    let items: [Components.Schemas.MediaProcessorListItemSchema]
    let pageState: NewAdminListPageState
}
