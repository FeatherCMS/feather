import AsyncHTTPClient
public import FeatherWebShared
public import FeatherWebAdmin
public import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
public import SystemAdminAPI

extension API {
    public struct Client: Sendable {
        public let client: SystemAdminAPI.Client

        // TODO: pass envrionment instead of api base url
        // NOTE: pagination + limit from user settings context?
        public init(
            apiBaseURL: URL,
            requestContext: AuthenticatedRequestContext
        ) {
            self.client = .init(
                serverURL: apiBaseURL,
                transport: AsyncHTTPClientTransport(
                    configuration: .init(
                        client: .shared,
                        timeout: .seconds(3)
                    )
                ),
                middlewares: [
                    ClientAPIAuthMiddleware(
                        sessionToken: requestContext.sessionToken
                    )
                ]
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (SystemAdminAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            do {
                return try await operation(client)
            }
            catch let error as OpenAPIRepositoryError {
                throw error
            }
            catch {
                throw OpenAPIRepositoryError.transport(
                    description: String(describing: error)
                )
            }
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            if statusCode == 409 {
                return .conflict
            }
            let body = try await responseBody?.collectString()
            return OpenAPIRepositoryError.parsedFailure(
                statusCode: statusCode,
                responseBody: body
            )
        }
    }
    }

    extension SystemAdminAPI.Client {
    private func defaultSearchPage()
        -> SystemAdminAPI.Components.Schemas.SearchPageSchema
    {
        .init(size: 20, number: 1)
    }

    func systemPermissionQuery(
        headers: SystemAdminAPI.Operations.SystemPermissionQuery.Input
            .Headers = .init()
    ) async throws -> SystemAdminAPI.Operations.SystemPermissionQuery.Output {
        try await systemPermissionQuery(
            headers: headers,
            body: .json(
                .init(
                    page: defaultSearchPage(),
                    filters: .init(search: nil)
                )
            )
        )
    }

    func systemVariableQuery(
        headers: SystemAdminAPI.Operations.SystemVariableQuery.Input.Headers =
            .init()
    ) async throws -> SystemAdminAPI.Operations.SystemVariableQuery.Output {
        try await systemVariableQuery(
            headers: headers,
            body: .json(
                .init(
                    page: defaultSearchPage(),
                    filters: .init(search: nil)
                )
            )
        )
    }
}
