import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.List {
    enum Interactor {}
}

extension WebAdmin.System.Permission.List.Interactor {
    protocol Interface: Sendable {

        func listSystemPermissions(
            page: Int,
            search: String?
        ) async throws -> WebAdmin.System.Permission.List.Model

    }
}
