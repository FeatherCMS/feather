import FeatherWebAdmin
import Hummingbird
import SystemAdminAPI
import SystemModule

extension Variable.List {
    enum Interactor {}
}

extension Variable.List.Interactor {
    protocol Interface: Sendable {

        func listSystemVariables(
            page: Int,
            search: String?
        ) async throws -> AdminListModel<
            Components.Schemas.SystemVariableListItemSchema
        >

    }
}
