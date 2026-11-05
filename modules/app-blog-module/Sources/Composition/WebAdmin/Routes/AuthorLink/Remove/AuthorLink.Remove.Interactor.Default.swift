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

extension AuthorLink.Remove.Interactor {
    struct Default: Interface {
        let repository: any AuthorLink.Remove.Repository.Interface

        func delete(authorID: String, ids: [String]) async throws {
            try await repository.delete(authorID: authorID, ids: ids)
        }
    }
}
