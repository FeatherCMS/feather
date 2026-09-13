import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminEditUserIdentityRoleOpenAPIRepository:
    AdminEditUserIdentityRoleRepository
{
    let api: UserAdminAPIClient
    init(api: UserAdminAPIClient) {
        self.api = api
    }

    func list() async throws -> [UserIdentityEditRoleOptionModel] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userRoleSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: 500, number: 1),
                        filters: .init(search: nil)
                    )
                )
            )
            switch response {
            case .ok(let ok):
                return try ok.body.json.data.items.map {
                    .init(id: $0.id, name: $0.name ?? "")
                }
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
