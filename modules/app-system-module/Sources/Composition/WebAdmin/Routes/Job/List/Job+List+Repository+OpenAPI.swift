import FeatherWebAdmin
import OpenAPIRuntime
import SystemAdminAPI
import SystemModule

extension Job.List.Repository {
    struct OpenAPI: Job.List.Repository.Interface {
        let api: API.Client

        func search(
            page: Int,
            search: String?,
            status: Int?
        ) async throws -> Components.Schemas.SystemJobSearchSchema {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.systemJobQuery(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(
                                size: Job.List.Router.pageSize,
                                number: page
                            ),
                            sort: [
                                .init(field: .queuedAt, direction: .desc)
                            ],
                            filters: .init(search: search, status: status)
                        )
                    )
                )

                switch response {
                case .ok(let value):
                    return try value.body.json
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
