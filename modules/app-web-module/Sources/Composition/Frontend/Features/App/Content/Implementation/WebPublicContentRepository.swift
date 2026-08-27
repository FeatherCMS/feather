import Foundation
import OpenAPIRuntime
import WebAppAPI

public struct WebPublicContentRepository: Sendable, AppPublicContentRepository {
    private let apiBaseURL: URL
    private let api: WebAppAPIClient

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.apiBaseURL = apiBaseURL
        self.api = WebAppAPIClient(
            apiBaseURL: apiBaseURL,
            sessionToken: sessionToken
        )
    }

    public func withSessionToken(
        _ sessionToken: String?
    ) -> any AppPublicContentRepository {
        Self(apiBaseURL: apiBaseURL, sessionToken: sessionToken)
    }

    public func resolveWebRoute(
        slug: String
    ) async throws -> WebAppAPI.Components.Schemas.WebMetadataSchema? {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMetadataGet(
                .init(path: .init(slug: slug))
            )
            switch response {
            case .ok(let value):
                return try value.body.json
            case .notFound:
                return nil
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
