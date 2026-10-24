public import BlogAppAPI
import OpenAPIRuntime

extension PublicContent.Repository {
    public struct OpenAPI: Sendable {
        public let api: API.App.Client

        public init(api: API.App.Client) {
            self.api = api
        }

        public func getRouteSettings() async throws
            -> BlogAppAPI.Components.Schemas.BlogRouteSettingsSchema
        {
            let response = try await api.client.blogSettingsGet(.init())
            switch response {
            case .ok(let value):
                return try value.body.json
            case .undocumented:
                throw CancellationError()
            }
        }
    }
}
