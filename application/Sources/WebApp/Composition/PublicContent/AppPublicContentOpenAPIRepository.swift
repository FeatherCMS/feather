import WebFrontend
import WebAppAPI
import Hummingbird
import OpenAPIRuntime

struct AppPublicContentOpenAPIRepository: AppPublicContentRepository {
    typealias WebComponents = WebAppAPI.Components

    let api: ApplicationAPI

    init(api: ApplicationAPI) {
        self.api = api
    }

    func withSessionToken(
        _ sessionToken: String?
    ) -> any AppPublicContentRepository {
        AppPublicContentOpenAPIRepository(
            api: api.withSessionToken(sessionToken)
        )
    }

    func resolveWebRoute(
        slug: String
    ) async throws -> WebComponents.Schemas.WebMetadataSchema? {
        try await api.withWebOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMetadataGet(
                .init(path: .init(slug: slug))
            )
            switch response {
            case .ok(let ok):
                return try ok.body.json
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
