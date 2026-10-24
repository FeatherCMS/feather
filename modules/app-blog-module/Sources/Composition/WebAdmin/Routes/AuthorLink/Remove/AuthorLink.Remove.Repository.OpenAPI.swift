import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func delete(authorID: String, ids: [String]) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.blogAuthorLinkDelete(
                    path: .init(blogAuthorId: authorID),
                    body: .json(.init(ids: ids))
                )
            }
        }
    }
}
