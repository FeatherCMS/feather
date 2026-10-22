public import BlogAppAPI

public struct PublicRouteSettings: Sendable {
    public let postListPath: String
    public let authorListPath: String
    public let tagListPath: String
    public let postPathPrefix: String
    public let authorPathPrefix: String
    public let tagPathPrefix: String

    public init(schema: BlogAppAPI.Components.Schemas.BlogRouteSettingsSchema) {
        postListPath = schema.postListPath
        authorListPath = schema.authorListPath
        tagListPath = schema.tagListPath
        postPathPrefix = schema.postPathPrefix
        authorPathPrefix = schema.authorPathPrefix
        tagPathPrefix = schema.tagPathPrefix
    }
}

public struct AppPublicContentOpenAPIRepository: Sendable {
    public let api: API.Client

    public init(api: API.Client) {
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
