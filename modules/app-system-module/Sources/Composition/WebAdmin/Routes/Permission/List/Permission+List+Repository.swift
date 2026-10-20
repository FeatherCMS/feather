import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Permission.List {
    enum Repository {}
}

extension Permission.List.Repository {
    protocol Interface: Sendable {

        func listSystemPermissions(
            page: Int,
            search: String?
        ) async throws -> Permission.List.Model

    }
}
