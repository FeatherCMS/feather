import FeatherAdmin
import Hummingbird
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Variable.List {
    enum Repository {}
}

extension WebAdmin.System.Variable.List.Repository {
    protocol Interface: Sendable {

        func listSystemVariables(
            page: Int,
            search: String?,
            ids: [String]?
        ) async throws
            -> SystemAdminAPI.Components.Responses
            .SystemVariableQueryItemSearchSchemaSearchResponse
    }
}
