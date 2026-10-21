import AuthAdminAPI
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

struct AdminListAuthCredentialOpenAPIRepository:
    AdminListAuthCredentialRepository
{
    let api: API.Client

    func list(
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
                        filters: .init(search: search, userId: nil)
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
