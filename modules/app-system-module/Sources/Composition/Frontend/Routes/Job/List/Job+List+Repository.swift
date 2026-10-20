import FeatherAdmin
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Job.List {
    enum Repository {}
}

extension WebAdmin.System.Job.List.Repository {
    protocol Interface: Sendable {
        func list() async throws -> [Components.Schemas.SystemJobSchema]
    }
}
