import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.List {
    enum Repository {}
}

extension WebAdmin.System.Permission.List.Repository {
    protocol Interface: Sendable {

        func listSystemPermissions(
            page: Int,
            search: String?
        ) async throws -> WebAdmin.System.Permission.List.Model

    }
}
