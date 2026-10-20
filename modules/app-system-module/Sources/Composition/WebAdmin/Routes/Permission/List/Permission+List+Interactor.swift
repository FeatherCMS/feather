import FeatherAdmin
import Hummingbird
import SystemModule

extension Permission.List {
    enum Interactor {}
}

extension Permission.List.Interactor {
    protocol Interface: Sendable {

        func listSystemPermissions(
            page: Int,
            search: String?
        ) async throws -> Permission.List.Model

    }
}
