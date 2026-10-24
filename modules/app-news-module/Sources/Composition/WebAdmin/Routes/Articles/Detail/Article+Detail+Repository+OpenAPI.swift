import FeatherWebAdmin
import FeatherWebShared
import NewsAdminAPI
import NewsApplication
import NewsModule
import OpenAPIRuntime

extension Article.Detail.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(
            id: String
        ) async throws -> Components.Schemas.NewsArticleDetailSchema {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsArticleGet(
                    .init(path: .init(newsArticleId: id))
                )
                switch response {
                case .ok(let value):
                    return try value.body.json
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .undocumented(let code, let value):
                    throw try await api.failure(
                        statusCode: code,
                        responseBody: value.body
                    )
                }
            }
        }
    }
}
