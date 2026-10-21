import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime
import UserAdminAPI
import UserModule

extension Role.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        func list(
            page: Int,
            size: Int,
            search: String?
        ) async throws
            -> UserAdminAPI.Components.Responses
            .UserRoleQueryItemSearchSchemaSearchResponse
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .userRoleQuery(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                page: .init(size: size, number: page),
                                filters: .init(search: search)
                            )
                        )
                    )
                switch response {
                case .ok(let ok):
                    return ok
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
