import FeatherAdmin
import FeatherContracts
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminViewUserIdentityOpenAPIRepository: AdminViewUserIdentityRepository {
    let api: UserAdminAPIClient
    init(
        api: UserAdminAPIClient
    ) {
        self.api = api
    }

    func load(
        id: String
    ) async throws -> UserIdentityDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userIdentityGet(
                path: .init(userIdentityId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let identity = try okResponse.body.json
                return .init(
                    id: identity.id,
                    name: identity.name,
                    status: identity.status.rawValue,
                    roleIds: Array(identity.roleIds ?? [])
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound
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
