import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Post.View {
    enum Repository {}
}

extension Post.View.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> Post.View.Details.Model
    }
}
