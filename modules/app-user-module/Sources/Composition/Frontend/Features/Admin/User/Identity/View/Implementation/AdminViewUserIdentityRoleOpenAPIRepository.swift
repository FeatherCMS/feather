import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminViewUserIdentityRoleOpenAPIRepository:
    AdminViewUserIdentityRoleRepository
{
    let api: UserAdminAPIClient

    init(api: UserAdminAPIClient) {
        self.api = api
    }

    func names(for ids: [String]) async throws -> [String] {
        guard !ids.isEmpty else { return [] }

        return try await api.withOpenAPIRepositoryErrorMapping { client in
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
                var namesByID: [String: String] = [:]
                for item in try ok.body.json.data.items {
                    if let name = item.name {
                        namesByID[item.id] = name
                    }
                }
                return ids.compactMap { namesByID[$0] }
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
