import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Permission.List {
    enum Interactor {}
}

extension Permission.List.Interactor {
    protocol Interface: Sendable {

        func list(
            page: Int,
            search: String?
        ) async throws -> Permission.List.Model

    }
}
