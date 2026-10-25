import BlogModule

extension Public.Post.List.Query {
    public struct Item: Sendable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let imageAssetId: String?
        public let authorIds: [String]
        public let tagIds: [String]

        public init(
            id: String,
            title: String,
            excerpt: String,
            imageAssetId: String?,
            authorIds: [String],
            tagIds: [String]
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.imageAssetId = imageAssetId
            self.authorIds = authorIds
            self.tagIds = tagIds
        }
    }
}
