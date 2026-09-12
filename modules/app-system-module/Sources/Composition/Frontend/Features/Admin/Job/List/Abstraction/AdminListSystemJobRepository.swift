import SystemAdminAPI

protocol AdminListSystemJobRepository: Sendable {
    func list() async throws -> [Components.Schemas.SystemJobSchema]
}
