import BlogModule

extension Public.Tag.Detail.Query {
    public struct Post: Sendable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let imageAssetId: String?

        public init(
            id: String,
            title: String,
            excerpt: String,
            imageAssetId: String?
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.imageAssetId = imageAssetId
        }
    }
}
