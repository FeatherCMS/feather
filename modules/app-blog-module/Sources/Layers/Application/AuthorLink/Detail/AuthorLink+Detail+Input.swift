public import BlogModule
public import FeatherApplication

extension AuthorLink.Detail {
    public struct Input: DTO {
        public let id: String
        public let authorId: String

        public init(id: String, authorId: String) {
            self.id = id
            self.authorId = authorId
        }
    }
}
