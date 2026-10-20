import FeatherAdmin
import SystemAdminAPI
import SystemModule

extension Variable.Add {
    enum Repository {}
}

extension Variable.Add.Repository {
    protocol Interface: Sendable {

        func create(
            input: Components.Schemas.SystemVariableCreateSchema
        ) async throws
    }
}
