public import BlogAppAPI
public import BlogModule

extension Settings {
    public struct PublicRoutes: Sendable {
        public let postListPath: String
        public let authorListPath: String
        public let tagListPath: String
        public let postPathPrefix: String
        public let authorPathPrefix: String
        public let tagPathPrefix: String

        public init(
            schema: BlogAppAPI.Components.Schemas.BlogRouteSettingsSchema
        ) {
            postListPath = schema.postListPath
            authorListPath = schema.authorListPath
            tagListPath = schema.tagListPath
            postPathPrefix = schema.postPathPrefix
            authorPathPrefix = schema.authorPathPrefix
            tagPathPrefix = schema.tagPathPrefix
        }
    }
}
