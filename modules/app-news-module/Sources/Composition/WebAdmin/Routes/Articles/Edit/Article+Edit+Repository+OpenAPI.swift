import FeatherWebAdmin
import FeatherWebShared
import NewsAdminAPI
import NewsApplication
import NewsModule
import OpenAPIRuntime

extension Article.Edit.Repository {
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

        func categories() async throws -> [Article.Form.CategoryOption] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsCategoryQuery(
                    .init(
                        body: .json(
                            .init(
                                page: .init(size: 200, number: 1),
                                filters: .init()
                            )
                        )
                    )
                )
                switch response {
                case .ok(let value):
                    let body = try value.body.json
                    return body.data.items.map {
                        .init(label: $0.title, value: $0.id)
                    }
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let code, let value):
                    throw try await api.failure(
                        statusCode: code,
                        responseBody: value.body
                    )
                }
            }
        }

        func update(
            id: String,
            input: Components.Schemas.NewsArticleCreateSchema
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsArticlePut(
                    .init(
                        path: .init(newsArticleId: id),
                        body: .json(input)
                    )
                )
                switch response {
                case .ok:
                    return
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
