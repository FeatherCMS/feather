import Foundation
import OpenAPIRuntime
public import WebAppAPI

public struct AppPublicContentOpenAPIRepository: AppPublicContentRepository {

    private let api: WebAppAPIClient

    public init(
        api: WebAppAPIClient
    ) {
        self.api = api
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
