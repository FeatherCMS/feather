import BlogAppAPI
public import BlogModule
import OpenAPIRuntime

extension PublicContent.Repository {
    public struct OpenAPI: Interface, Sendable {
        public let api: API.App.Client

        public init(api: API.App.Client) {
            self.api = api
        }

        public func getRouteSettings() async throws -> Settings.PublicRoutes {
            let response = try await api.client.blogSettingsGet(.init())
            switch response {
            case .ok(let value):
                let schema = try value.body.json
                return Settings.PublicRoutes(
                    postListPath: schema.postListPath,
                    authorListPath: schema.authorListPath,
                    tagListPath: schema.tagListPath,
                    postPathPrefix: schema.postPathPrefix,
                    authorPathPrefix: schema.authorPathPrefix,
                    tagPathPrefix: schema.tagPathPrefix
                )
            case .undocumented:
                throw CancellationError()
            }
        }
    }
}
