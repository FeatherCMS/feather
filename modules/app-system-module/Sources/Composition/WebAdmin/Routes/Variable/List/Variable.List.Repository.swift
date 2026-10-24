import FeatherWebAdmin
import Hummingbird
import SystemAdminAPI
import SystemModule

extension Variable.List {
    enum Repository {}
}

extension Variable.List.Repository {
    protocol Interface: Sendable {

        func search(
            page: Int,
            search: String?,
            ids: [String]?
        ) async throws
            -> SystemAdminAPI.Components.Responses
            .SystemVariableQueryItemSearchSchemaSearchResponse
    }
}
