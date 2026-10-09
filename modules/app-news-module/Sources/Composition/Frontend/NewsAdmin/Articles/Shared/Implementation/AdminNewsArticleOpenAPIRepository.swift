import FeatherAdmin
import NewsAdminAPI
import OpenAPIRuntime

struct AdminNewsArticleOpenAPIRepository: AdminNewsArticleRepository {
    let api: NewsAdminAPIClient

    func list(
        page: Int,
        search: String?
    ) async throws -> AdminNewsArticleListModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsArticleSearch(
                .init(
                    body: .json(
                        .init(
                            page: .init(size: 20, number: page),
                            filters: .init(search: search)
                        )
                    )
                )
            )
            switch response {
            case .ok(let value):
                let body = try value.body.json
                return .init(
                    items: body.data.items.map {
                        .init(id: $0.id, title: $0.title, excerpt: $0.excerpt)
                    },
                    total: body.data.total,
                    page: body.query.page.number,
                    pageSize: body.query.page.size
                )
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

    func get(
        id: String
    ) async throws
        -> Components.Schemas.NewsArticleDetailSchema
    {
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

    func categories() async throws -> [AdminNewsArticleCategoryOption] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsCategorySearch(
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

    func create(
        input: Components.Schemas.NewsArticleCreateSchema
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsArticleCreate(
                .init(body: .json(input))
            )
            switch response {
            case .created:
                return
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
            let response = try await client.newsArticleUpdate(
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

    func remove(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsArticleRemove(
                .init(
                    body: .json(
                        .init(ids: [id], results: false, summary: false)
                    )
                )
            )
            switch response {
            case .ok:
                return
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
}
