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

extension AuthorLink.View.Interactor {
    struct Default: Interface {
        let repository: any AuthorLink.View.Repository.Interface

        func execute(
            authorID: String,
            id: String
        ) async throws -> AuthorLink.View.Model {
            try await repository.get(authorID: authorID, id: id)
        }
    }
}
