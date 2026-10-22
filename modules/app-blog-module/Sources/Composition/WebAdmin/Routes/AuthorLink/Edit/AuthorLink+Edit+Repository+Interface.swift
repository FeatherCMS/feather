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

extension AuthorLink.Edit.Repository {
    protocol Interface: Sendable {
        func load(
            authorID: String,
            id: String
        ) async throws -> AuthorLink.View.Model

        func update(
            authorID: String,
            id: String,
            input: AuthorLink.Form.Input
        ) async throws
    }
}
