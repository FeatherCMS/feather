import BlogAdminAPI
import BlogModule
import FeatherWebShared
import OpenAPIRuntime

extension Author.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func delete(ids: [String]) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.blogAuthorDelete(
                    body: .json(.init(ids: ids))
                )
            }
        }
    }
}
