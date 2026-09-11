import SystemAdminAPI
import FeatherAdmin
import Hummingbird

protocol AdminListSystemVariableInteractor: Sendable {

    func listSystemVariables(
        page: Int,
        search: String?
    ) async throws -> AdminListModel<Components.Schemas.SystemVariableListItemSchema>

    func remove(
        ids: [String]
    ) async throws
}
