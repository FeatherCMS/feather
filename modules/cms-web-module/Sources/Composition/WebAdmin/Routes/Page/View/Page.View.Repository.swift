import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.View {
    enum Repository {}
}

extension Page.View.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> Page.Details.Model
    }
}
