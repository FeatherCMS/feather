import FeatherAdmin
import Hummingbird
import SystemAdminAPI

protocol AdminListSystemVariableInteractor: Sendable {

    func listSystemVariables(
        page: Int,
        search: String?
    ) async throws -> AdminListModel<
        Components.Schemas.SystemVariableListItemSchema
    >

}
