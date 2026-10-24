import FeatherWebAdmin
import FeatherWebShared
import Foundation
import OpenAPIRuntime
import SystemAdminAPI
import SystemWebAdmin
import WebModule

extension MenuItem.Permission.Repository {
    struct OpenAPI: Interface {
        let api: SystemWebAdmin.API.Client

        func listNames(  // empty
            ) async throws -> [String]
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.systemPermissionList(
                    .init(
                        query: .init(limit: 100),
                        headers: .init(accept: [.init(contentType: .json)])
                    )
                )

                switch response {
                case SystemAdminAPI.Operations.SystemPermissionList.Output
                    .ok(let okResponse):
                    let items = try okResponse.body.json
                    return
                        items
                        .compactMap(\.name)
                        .filter { !$0.isEmpty }
                        .sorted {
                            $0.localizedCaseInsensitiveCompare($1)
                                == .orderedAscending
                        }
                case SystemAdminAPI.Operations.SystemPermissionList.Output
                    .unauthorized(_):
                    throw OpenAPIRepositoryError.unauthorized
                case SystemAdminAPI.Operations.SystemPermissionList.Output
                    .forbidden(_):
                    throw OpenAPIRepositoryError.forbidden
                case SystemAdminAPI.Operations.SystemPermissionList.Output
                    .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }
    }
}
