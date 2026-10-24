import FeatherWebAdmin
import SystemAdminAPI
import SystemModule

extension Variable.Edit {
    enum Repository {}
}

extension Variable.Edit.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Variable.Edit.Model

        func update(
            id: String,
            input: Components.Schemas.SystemVariableCreateSchema
        ) async throws
    }
}
