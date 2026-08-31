import SystemAdminAPI

struct AdminGetSystemJobDefaultInteractor: AdminGetSystemJobInteractor {
    let repository: any AdminGetSystemJobRepository

    func get(
        id: String
    ) async throws -> Components.Schemas.SystemJobSchema {
        try await repository.get(id: id)
    }
}
