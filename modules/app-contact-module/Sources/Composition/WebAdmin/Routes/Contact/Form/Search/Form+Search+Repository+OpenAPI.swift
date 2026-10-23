import ContactAdminAPI
import ContactModule
import FeatherWebShared
import OpenAPIRuntime

extension Form.Search.Repository {
    struct OpenAPI: Interface {
        let api: ContactAdminAPIClient

        func search(
            page: Int,
            search: String
        ) async throws -> Form.Search.Model.Result {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let query = Components.Schemas
                    .ContactFormQueryItemSearchRequestQuerySchema(
                        page: .init(
                            size: Form.Search.Model.pageSize,
                            number: page
                        ),
                        sort: [
                            .init(field: .name, direction: .asc)
                        ],
                        filters: .init(search: search.isEmpty ? nil : search)
                    )
                let response = try await client.contactFormQuery(
                    .init(body: .json(query))
                )
                switch response {
                case .ok(let value):
                    let result = try value.body.json
                    return .init(
                        items: result.data.items.map {
                            .init(key: $0.key, name: $0.name)
                        },
                        total: result.data.total
                    )
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }
    }
}
