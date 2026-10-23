import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension Email.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        let userAPI: UserWebAdmin.API.Client
        private let listUnauthorizedMessage =
            "Please sign in again to view user emails."
        private let deleteUnauthorizedMessage =
            "Please sign in again to delete this user email."

        func list(
            page: Int,
            size: Int,
            search: String?,
            userID: String?
        ) async throws -> Email.List.Result {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let query = AuthAdminAPI.Components.Schemas
                    .AuthEmailQuerySchemasItemSearchRequestQuerySchema(
                        page: .init(size: size, number: page),
                        filters: .init(
                            search: search,
                            identityId: userID
                        )
                    )
                let response = try await client.authEmailQuery(
                    .init(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(query)
                    )
                )
                switch response {
                case .ok(let ok):
                    let result = try ok.body.json
                    let body = result.data.items
                    var identityNames: [String: String] = [:]
                    for identityID in Set(body.map(\.identityId)) {
                        let identityResponse =
                            try await userAPI
                            .withOpenAPIRepositoryErrorMapping { client in
                                try await client.userIdentityGet(
                                    path: .init(userIdentityId: identityID),
                                    headers: .init(accept: [
                                        .init(contentType: .json)
                                    ])
                                )
                            }
                        if case .ok(let identityOK) = identityResponse {
                            identityNames[identityID] = try identityOK.body.json
                                .name
                        }
                    }
                    return .init(
                        items: body,
                        identityNames: identityNames,
                        total: result.data.total,
                        page: page,
                        size: size
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
