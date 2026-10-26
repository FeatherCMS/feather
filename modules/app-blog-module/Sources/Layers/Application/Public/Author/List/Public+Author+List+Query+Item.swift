import BlogModule

extension Public.Author.List.Query {
    public struct Item: Sendable {
        public let id: String
        public let name: String
        public let excerpt: String
        public let content: String
        public let profileImageAssetId: String?

        public init(
            id: String,
            name: String,
            excerpt: String,
            content: String,
            profileImageAssetId: String?
        ) {
            self.id = id
            self.name = name
            self.excerpt = excerpt
            self.content = content
            self.profileImageAssetId = profileImageAssetId
        }
    }
}
