import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminListUserRoleOpenAPIRepository: AdminListUserRoleRepository {
    let api: UserAdminAPIClient
    init(api: UserAdminAPIClient) {
        self.api = api
    }

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> UserAdminAPI.Components.Responses
        .UserRoleListItemSearchSchemaSearchResponse
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userRoleSearch(
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
