import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.Remove {
    enum Repository {}
}

extension MenuItem.Remove.Repository {
    protocol Interface: Sendable {
        func get(
            menuId: String,
            id: String
        ) async throws -> MenuItem.View.Model

        func delete(
            menuId: String,
            id: String
        ) async throws
    }
}
