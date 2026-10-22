import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.View {
    enum Repository {}
}

extension Menu.View.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> MenuDetailsModel
    }
}
