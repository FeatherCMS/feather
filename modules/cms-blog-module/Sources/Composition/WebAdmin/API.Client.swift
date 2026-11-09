public import BlogAdminAPI
import BlogWebShared
public import FeatherWebAdmin
public import FeatherWebShared
public import MediaWebAdmin
public import OpenAPIRuntime
import WebModuleWebAdmin
public import WebAdminAPI

public enum API {
    public struct Client: Sendable {
        public let client: BlogAdminAPI.Client
        public let accountSettings: AccountSettingsModel
        public let adminDateFormatter: AdminDateFormatter
        private let mediaClient: MediaWebAdmin.API.Client
        private let webClient: WebModuleWebAdmin.API.Client

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            self.accountSettings = requestContext.accountSettings
            self.adminDateFormatter = requestContext.adminDateFormatter
            let configuration = BlogAPIClientSupport.configuration(
                sessionToken: requestContext.sessionToken
            )
            self.mediaClient = .init(
                environment: environment,
                requestContext: requestContext
            )
            self.webClient = .init(
                environment: environment,
                requestContext: requestContext
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public func mediaAdminAPI() -> MediaWebAdmin.API.Client {
            mediaClient
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
                        .init(referenceType: referenceType, referenceIds: referenceIDs)
                    )
                )
                switch response {
                case .ok(let okResponse):
                    return try okResponse.body.json
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
            _ operation: @Sendable (BlogAdminAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await BlogAPIClientSupport.withOpenAPIRepositoryErrorMapping(
                operation,
                using: client
            )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await BlogAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }
    }
}
