import FeatherAdmin
import Foundation
import OpenAPIRuntime
import SystemAdminAPI
import SystemFrontend

struct AdminSystemPermissionOpenAPIRepository:
    AdminSystemPermissionRepository
{
    let api: SystemAdminAPIClient

    func listNames(// empty
        ) async throws -> [String]
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemPermissionSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: 300, number: 1),
                        filters: .init(search: nil)
                    )
                )
            )

            switch response {
            case .ok(let okResponse):
                let items = try okResponse.body.json.data.items
                return
                    items
                    .compactMap(\.name)
                    .filter { !$0.isEmpty }
                    .sorted {
                        $0.localizedCaseInsensitiveCompare($1)
                            == .orderedAscending
                    }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view system permissions."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access system permissions."
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
