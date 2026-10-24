import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime
import RedirectAdminAPI
import RedirectWebShared

extension API {
    struct Client: Sendable {
        let client: RedirectAdminAPI.Client

        init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            let configuration = RedirectAPIClientSupport.configuration(
                sessionToken: requestContext.sessionToken
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (RedirectAdminAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await RedirectAPIClientSupport.withOpenAPIRepositoryErrorMapping(
                operation,
                using: client
            )
        }

        func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await RedirectAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }
    }
}
