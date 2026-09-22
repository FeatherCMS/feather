import FeatherAdmin
import SystemAdminAPI

protocol AdminEditSystemVariableRepository: Sendable {

    func load(
        id: String
    ) async throws -> SystemVariableEditModel

    func update(
        id: String,
        input: Components.Schemas.SystemVariableCreateSchema
    ) async throws
}
