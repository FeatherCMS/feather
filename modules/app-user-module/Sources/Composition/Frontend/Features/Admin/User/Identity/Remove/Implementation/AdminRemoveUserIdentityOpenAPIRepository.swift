import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminRemoveUserIdentityOpenAPIRepository:
    AdminRemoveUserIdentityRepository
{
    let api: UserAdminAPIClient
    private let unauthorizedMessage =
        "Please sign in again to delete this user identity."

    init(api: UserAdminAPIClient) {
        self.api = api
    }

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.userIdentityDelete(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }
}
