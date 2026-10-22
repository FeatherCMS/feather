import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Permission.List.Interactor {
    protocol Interface: Sendable {

        func listSystemPermissions(
            page: Int,
            search: String?
        ) async throws -> Permission.List.Model

    }
}
