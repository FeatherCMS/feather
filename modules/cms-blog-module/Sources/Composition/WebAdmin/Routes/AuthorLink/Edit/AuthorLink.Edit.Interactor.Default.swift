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

extension AuthorLink.Edit.Interactor {
    struct Default: Interface {
        let repository: any AuthorLink.Edit.Repository.Interface

        func load(
            authorID: String,
            id: String
        ) async throws -> AuthorLink.View.Model {
            try await repository.load(authorID: authorID, id: id)
        }

        func update(
            authorID: String,
            id: String,
            input: AuthorLink.Form.Input
        ) async throws {
            try await repository.update(
                authorID: authorID,
                id: id,
                input: input
            )
        }
    }
}
