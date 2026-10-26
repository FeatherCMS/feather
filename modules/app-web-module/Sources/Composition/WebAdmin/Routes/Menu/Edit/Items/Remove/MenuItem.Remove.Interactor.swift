import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.Remove {
    enum Interactor {}
}

extension MenuItem.Remove.Interactor {
    protocol Interface: Sendable {
        func get(
            menuId: String,
            id: String
        ) async throws -> MenuItem.View.Model

        func delete(
            menuId: String,
            ids: [String]
        ) async throws
    }
}
