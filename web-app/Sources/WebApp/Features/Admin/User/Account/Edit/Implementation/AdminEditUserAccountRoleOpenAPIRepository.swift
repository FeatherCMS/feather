import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditUserAccountRoleOpenAPIRepository:
    AdminEditUserAccountRoleRepository
{
    let api: AdminAPI
    private let unauthorizedMessage =
        "Please sign in again to view user roles."

    init(api: AdminAPI) {
        self.api = api
    }

    func list() async throws -> [AdminEditUserAccountRoleOptionModel] {
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
                    .init(id: $0.id, name: $0.name)
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: unauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access user roles."
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
