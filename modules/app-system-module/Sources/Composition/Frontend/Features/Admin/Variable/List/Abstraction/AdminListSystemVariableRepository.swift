import FeatherAdmin
import Hummingbird
import SystemAdminAPI

protocol AdminListSystemVariableRepository: Sendable {

    func listSystemVariables(
        page: Int,
        search: String?
    ) async throws
        -> SystemAdminAPI.Components.Responses
        .SystemVariableListItemSearchSchemaSearchResponse
}
