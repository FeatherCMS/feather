import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.View {
    enum Repository {}
}

extension WebModule.Menu.View.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> MenuDetailsModel
    }
}
