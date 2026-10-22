import FeatherWebAdmin
import Hummingbird
import SystemAdminAPI
import SystemModule

extension Variable.List.Repository {
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
