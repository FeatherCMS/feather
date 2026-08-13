import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

struct AdminListAuthCredentialOpenAPIRepository:
    AdminListAuthCredentialRepository
{
    let api: AuthAdminAPIClient

    func list(
        identityId: String,
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [AuthAdminAPI.Components.Schemas.AuthCredentialListItemSchema],
        total: Int,
        page: Int,
        size: Int
    ) {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.authCredentialSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: size, number: page),
                        filters: .init(search: search, userId: identityId)
                    )
                )
            )
            switch response {
            case .ok(let ok):
                let body = try ok.body.json
                return (
                    items: body.data.items,
                    total: body.data.total,
                    page: body.query.page.number,
                    size: body.query.page.size
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view credentials."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot access credentials."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
