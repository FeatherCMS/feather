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
import WebComponents
import WebBuilders

struct AdminListAuthCredentialIdentityOpenAPIRepository:
    AdminListAuthCredentialIdentityRepository
{
    let api: UserAdminAPIClient

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [UserAdminAPI.Components.Schemas.UserIdentityListItemSchema],
        total: Int,
        page: Int,
        size: Int
    ) {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userIdentitySearch(
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
                let body = try ok.body.json
                return (
                    items: body.data.items,
                    total: body.data.total,
                    page: body.query.page.number,
                    size: body.query.page.size
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view user identities."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot access user identities."
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
