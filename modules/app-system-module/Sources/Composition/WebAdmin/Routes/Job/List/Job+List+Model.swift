import FeatherAdmin
import SystemAdminAPI
import SystemModule

extension Job.List {
    struct Model: Sendable {
        let items: [Components.Schemas.SystemJobSchema]
        let pageState: AdminListPageState
    }
}
