import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminListUserIdentityOpenAPIRepository:
    AdminListUserIdentityRepository
{
    let api: UserAdminAPIClient
    func list(
        page: Int,
        size: Int,
        search: String?,
        role: String?
    ) async throws
        -> UserAdminAPI.Components.Responses
        .UserIdentityListItemSearchSchemaSearchResponse
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userIdentitySearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: size, number: page),
                            filters: .init(search: search, role: role)
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
