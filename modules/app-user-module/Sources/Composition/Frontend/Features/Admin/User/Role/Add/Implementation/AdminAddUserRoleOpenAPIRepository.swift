import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminAddUserRoleOpenAPIRepository: AdminAddUserRoleRepository {

    let api: UserAdminAPIClient

    func create(
        payload: UserRoleFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userRoleCreate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            name: payload.name,
                            notes: payload.notes
                        )
                    )
                )
            switch response {
            case .created:
                return
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
