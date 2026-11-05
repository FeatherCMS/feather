public import BlogModule
public import FeatherApplication

extension AuthorLink.Add {
    public struct Input: DTO {
        public let authorId: String
        public let label: String
        public let url: String
        public let priority: Int
        public let isBlank: Bool
        public let permission: String
        public let notes: String

        public init(
            authorId: String,
            label: String,
            url: String,
            priority: Int,
            isBlank: Bool,
            permission: String,
            notes: String
        ) {
            self.authorId = authorId
            self.label = label
            self.url = url
            self.priority = priority
            self.isBlank = isBlank
            self.permission = permission
            self.notes = notes
        }
    }
}
