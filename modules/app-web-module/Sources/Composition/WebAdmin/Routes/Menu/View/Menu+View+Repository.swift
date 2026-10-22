import FeatherWebAdmin
import WebDomain
import OpenAPIRuntime

extension WebDomain.Menu.View {
    enum Repository {}
}

extension WebDomain.Menu.View.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> MenuDetailsModel
    }
}
