public import BlogModule
public import FeatherApplication
public import FeatherDomain

extension AuthorLink.Edit {
    public struct Input: DTO {
        public let id: String
        public let authorId: String
        public let label: FieldChange<String>
        public let url: FieldChange<String>
        public let priority: FieldChange<Int>
        public let isBlank: FieldChange<Bool>
        public let permission: FieldChange<String>
        public let notes: FieldChange<String>

        public init(
            id: String,
            authorId: String,
            label: FieldChange<String>,
            url: FieldChange<String>,
            priority: FieldChange<Int>,
            isBlank: FieldChange<Bool>,
            permission: FieldChange<String>,
            notes: FieldChange<String>
        ) {
            self.id = id
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
