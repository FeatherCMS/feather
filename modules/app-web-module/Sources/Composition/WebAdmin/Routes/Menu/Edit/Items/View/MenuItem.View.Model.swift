import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.View {
    struct Model: Sendable {
        let id: String
        let menuId: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let authentication: String
        let notes: String?
    }
}
