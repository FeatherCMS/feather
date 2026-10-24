import AccountAdminAPI
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Invitation.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func list(
            page: Int,
            size: Int,
            search: String?
        ) async throws -> Invitation.List.Result {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.accountInvitationQuery(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: size, number: page),
                            filters: .init(search: search)
                        )
                    )
                )
                switch response {
                case .ok(let value):
                    let body = try value.body.json
                    return .init(
                        items: body.data.items,
                        total: body.data.total,
                        page: body.query.page.number,
                        size: body.query.page.size
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
