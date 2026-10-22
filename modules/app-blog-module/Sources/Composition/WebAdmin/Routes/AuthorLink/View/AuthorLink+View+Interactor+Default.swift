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
        let repository: any AuthorLink.Detail.Repository.Interface

        func execute(
            _ input: AuthorLink.View.Model
        ) async throws -> AuthorLink.Detail.Model {
            try await repository.get(authorID: input.authorID, id: input.id)
        }
    }
}
