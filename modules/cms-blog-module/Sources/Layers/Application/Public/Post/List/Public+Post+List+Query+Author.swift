import BlogModule

extension Public.Post.List.Query {
    public struct Author: Sendable {
        public let id: String
        public let name: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?

        public init(
            id: String,
            name: String,
            excerpt: String,
            content: String,
            imageAssetId: String?
        ) {
            self.id = id
            self.name = name
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
        }
    }
}
