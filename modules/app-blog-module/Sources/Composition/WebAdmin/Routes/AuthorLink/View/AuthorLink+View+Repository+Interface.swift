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

extension AuthorLink.View.Repository {
    protocol Interface: Sendable {
        func get(authorID: String, id: String) async throws
            -> AuthorLink.View.Model
    }
}
