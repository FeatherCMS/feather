import FeatherWebShared
import RedirectAppAPI
import RedirectWebShared

extension API {
    struct Client: Sendable {
        let client: RedirectAppAPI.Client

        init(environment: AppEnvironment) {
            let configuration = RedirectAPIClientSupport.configuration(
                sessionToken: nil
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (RedirectAppAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await RedirectAPIClientSupport.withOpenAPIRepositoryErrorMapping(
                operation,
                using: client
            )
        }
    }
}
