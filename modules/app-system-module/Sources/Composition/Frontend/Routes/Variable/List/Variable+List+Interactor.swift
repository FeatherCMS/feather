import FeatherAdmin
import Hummingbird
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Variable.List {
    enum Interactor {}
}

extension WebAdmin.System.Variable.List.Interactor {
    protocol Interface: Sendable {

        func listSystemVariables(
            page: Int,
            search: String?
        ) async throws -> AdminListModel<
            Components.Schemas.SystemVariableListItemSchema
        >

    }
}
