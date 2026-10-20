import FeatherWebAdmin
import SystemAdminAPI
import SystemModule

extension Job.List {
    enum Repository {}
}

extension Job.List.Repository {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?,
            status: Int?
        ) async throws -> Components.Schemas.SystemJobSearchSchema
    }
}
