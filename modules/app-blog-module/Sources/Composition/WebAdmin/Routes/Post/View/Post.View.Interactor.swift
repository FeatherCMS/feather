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
    enum Interactor {}
}

extension Post.View.Interactor {
    protocol Interface: Sendable {
        func execute(id: String) async throws -> Post.View.Model
    }
}
