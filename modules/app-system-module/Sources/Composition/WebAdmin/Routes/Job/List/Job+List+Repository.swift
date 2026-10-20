import FeatherAdmin
import SystemAdminAPI
import SystemModule

extension Job.List {
    enum Repository {}
}

extension Job.List.Repository {
    protocol Interface: Sendable {
        func list() async throws -> [Components.Schemas.SystemJobSchema]
    }
}
