import FeatherAdmin
import NewsAdminAPI
import OpenAPIRuntime

struct AdminNewsCategoryOpenAPIRepository: AdminNewsCategoryRepository {
    let api: NewsAdminAPIClient

    func list(
        page: Int,
        search: String?
    ) async throws -> AdminNewsCategoryListModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsCategorySearch(
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
        -> Components.Schemas.NewsCategoryDetailSchema
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsCategoryGet(
                .init(path: .init(newsCategoryId: id))
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

    func create(
        input: Components.Schemas.NewsCategoryCreateSchema
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsCategoryCreate(
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
        input: Components.Schemas.NewsCategoryCreateSchema
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsCategoryUpdate(
                .init(path: .init(newsCategoryId: id), body: .json(input))
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
            let response = try await client.newsCategoryRemove(
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
