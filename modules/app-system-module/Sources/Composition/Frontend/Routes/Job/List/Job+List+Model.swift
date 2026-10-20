import FeatherAdmin
import SystemAdminAPI

extension WebAdmin.System.Job.List {
    struct Model: Sendable {
        let items: [Components.Schemas.SystemJobSchema]
        let pageState: AdminListPageState
    }
}
