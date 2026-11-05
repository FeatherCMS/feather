public import FeatherApplication
public import FeatherDomain
public import MediaModule

extension Asset.Folder.Edit {
    public struct Input: DTO {
        public let id: String
        public let name: FieldChange<String>
        public let parentId: OptionalFieldChange<String>

        public init(
            id: String,
            name: FieldChange<String> = .unchanged,
            parentId: OptionalFieldChange<String> = .unchanged
        ) {
            self.id = id
            self.name = name
            self.parentId = parentId
        }
    }
}
