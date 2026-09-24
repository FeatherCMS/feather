import FeatherAdmin
import SystemAdminAPI

protocol AdminAddSystemVariableRepository: Sendable {

    func create(
        input: Components.Schemas.SystemVariableCreateSchema
    ) async throws
}
