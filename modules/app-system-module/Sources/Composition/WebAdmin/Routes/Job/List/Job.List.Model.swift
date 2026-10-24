import FeatherWebAdmin
import SystemAdminAPI
import SystemModule

extension Job.List {
    struct Model: Sendable {
        let items: [Components.Schemas.SystemJobQueryItemSchema]
        let pageState: AdminListPageState
    }
}
