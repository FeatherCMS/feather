import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.View {
    struct Input: Sendable {
        let menuId: String
        let id: String
    }
}
