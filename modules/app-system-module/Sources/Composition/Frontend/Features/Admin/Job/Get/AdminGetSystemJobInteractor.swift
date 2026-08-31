import SystemAdminAPI

protocol AdminGetSystemJobInteractor: Sendable {
    func get(
        id: String
    ) async throws -> Components.Schemas.SystemJobSchema
}
