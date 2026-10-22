import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain

extension Menu.List {
    enum Interactor {}
}

extension Menu.List.Interactor {
    protocol Interface: Sendable {

        func listWebMenus(
            page: Int,
            search: String?
        ) async throws -> Menu.List.Model

    }
}
