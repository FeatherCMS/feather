import BlogAdminAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension Post.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func delete(ids: [String]) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.blogPostDelete(
                    body: .json(.init(ids: ids))
                )
            }
        }
    }
}
