import FeatherWebAdmin
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension WebModule.Menu.View {
    struct Model: Sendable {
        let id: String
        let key: String
        let name: String
        let notes: String?
    }
}
