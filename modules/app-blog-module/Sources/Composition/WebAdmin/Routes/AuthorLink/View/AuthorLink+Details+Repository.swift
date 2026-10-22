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

extension AuthorLink {
    enum Details {}
}

extension AuthorLink.Details {
    enum Repository {}
}

extension AuthorLink.Details.Repository {
    protocol Interface: Sendable {
        func get(authorID: String, id: String) async throws
            -> AuthorLink.Details.Model
    }
}
