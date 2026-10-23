import BlogModule

extension Public.Post.Detail.Query {
    public struct Output: Sendable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let authorIds: [String]
        public let tagIds: [String]

        public init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            authorIds: [String],
            tagIds: [String]
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.authorIds = authorIds
            self.tagIds = tagIds
        }
    }
}
