import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.View {
    enum Repository {}
}

extension MenuItem.View.Repository {
    protocol Interface: Sendable {
        func get(
            menuId: String,
            id: String
        ) async throws -> MenuItem.View.Model
    }
}
