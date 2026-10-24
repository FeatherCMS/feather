public import BlogModule
public import FeatherApplication

extension AuthorLink.List {
    public struct Input: DTO {
        public let authorId: String

        public init(authorId: String) {
            self.authorId = authorId
        }
    }
}
