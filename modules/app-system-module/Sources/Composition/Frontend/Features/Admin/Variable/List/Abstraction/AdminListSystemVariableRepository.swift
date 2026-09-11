import SystemAdminAPI
import FeatherAdmin
import Hummingbird

protocol AdminListSystemVariableRepository: Sendable {

    func listSystemVariables(
        page: Int,
        search: String?
    ) async throws -> SystemAdminAPI.Components.Responses.SystemVariableListItemSearchSchemaSearchResponse

    func delete(
        id: String
    ) async throws
}
