public import FeatherWebAdmin
public import FeatherWebShared
public import MediaWebAdmin
public import NewsAdminAPI
import NewsWebShared
public import OpenAPIRuntime
public import WebAdminAPI
import WebModuleWebAdmin

extension API {
    public struct Client: Sendable {
        public let client: NewsAdminAPI.Client
        public let accountSettings: AccountSettingsModel
        public let adminDateFormatter: AdminDateFormatter
        private let environment: AppEnvironment
        private let requestContext: AuthenticatedRequestContext
        private let webClient: WebModuleWebAdmin.API.Client

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            self.accountSettings = requestContext.accountSettings
            self.adminDateFormatter = requestContext.adminDateFormatter
            self.environment = environment
            self.requestContext = requestContext
            self.webClient = .init(
                environment: environment,
                requestContext: requestContext
            )
            let configuration = NewsAPIClientSupport.configuration(
                sessionToken: requestContext.sessionToken
            )
            client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public func mediaAdminAPI() -> MediaWebAdmin.API.Client {
            .init(
                environment: environment,
                requestContext: requestContext
            )
        }

        public func resolveWebMetadata(
            referenceType: String,
            referenceIDs: [String]
        ) async throws -> [WebAdminAPI.Components.Schemas.MetadataResolveItemSchema] {
            guard !referenceIDs.isEmpty else { return [] }
            return try await webClient.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.metadataResolve(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            referenceType: referenceType,
                            referenceIds: referenceIDs
                        )
                    )
                )
                switch response {
                case .ok(let value):
                    return try value.body.json
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await webClient.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (NewsAdminAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await NewsAPIClientSupport.withOpenAPIRepositoryErrorMapping(
                operation,
                using: client
            )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await NewsAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }
    }
}
