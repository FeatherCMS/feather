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

extension MagicLink.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        private let listUnauthorizedMessage =
            "Please sign in again to view user magic links."
        private let deleteUnauthorizedMessage =
            "Please sign in again to delete this user magic link."

        func search(
            page: Int,
            size: Int,
            search: String?,
            userID: String?
        ) async throws -> MagicLink.List.Result {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .authMagicLinkQuery(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                page: .init(size: size, number: page),
                                filters: .init(search: search, userId: userID)
                            )
                        )
                    )
                switch response {
                case .ok(let ok):
                    let body = try ok.body.json
                    let emails = try await listEmails()
                    var emailByAuthEmailID: [String: String] = [:]
                    for email in emails {
                        precondition(
                            emailByAuthEmailID.updateValue(
                                email.email,
                                forKey: String(email.id)
                            ) == nil
                        )
                    }
                    return .init(
                        items: body.data.items,
                        emailByAuthEmailId: emailByAuthEmailID,
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

        private func listEmails() async throws
            -> [AuthAdminAPI.Components.Schemas.AuthEmailSchemasDetail]
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authEmailList(
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let ok): return try ok.body.json
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
