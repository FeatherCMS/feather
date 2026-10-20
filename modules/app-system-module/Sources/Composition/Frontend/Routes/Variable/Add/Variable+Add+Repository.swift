import FeatherAdmin
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Variable.Add {
    enum Repository {}
}

extension WebAdmin.System.Variable.Add.Repository {
    protocol Interface: Sendable {

        func create(
            input: Components.Schemas.SystemVariableCreateSchema
        ) async throws
    }
}
