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

extension AuthorLink.View {
    enum Interactor {}
}

extension AuthorLink.View.Interactor {
    protocol Interface: Sendable {
        func execute(authorID: String, id: String) async throws
            -> AuthorLink.View.Model
    }
}
