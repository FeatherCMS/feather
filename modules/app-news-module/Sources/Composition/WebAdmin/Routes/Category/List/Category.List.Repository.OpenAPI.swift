import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import NewsAdminAPI
import NewsModule
import OpenAPIRuntime

extension Category.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func search(
            page: Int,
            search: String?
        ) async throws -> Category.List.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsCategoryQuery(
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
                            .init(
                                id: $0.id,
                                title: $0.title,
                                excerpt: $0.excerpt
                            )
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
    }
}
