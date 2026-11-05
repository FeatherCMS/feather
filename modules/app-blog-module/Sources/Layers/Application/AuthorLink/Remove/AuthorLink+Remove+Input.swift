public import BlogModule
public import FeatherApplication

extension AuthorLink.Remove {
    public struct Input: DTO {
        public let ids: [String]
        public let authorId: String

        public init(ids: [String], authorId: String) {
            self.ids = ids
            self.authorId = authorId
        }
    }
}
