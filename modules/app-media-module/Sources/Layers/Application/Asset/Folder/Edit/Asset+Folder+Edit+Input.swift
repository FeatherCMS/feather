public import FeatherApplication
public import FeatherDomain
public import MediaModule

extension Asset.Folder.Edit {
    public struct Input: DTO {
        public let id: String
        public let name: FieldChange<String>
        public init(id: String, name: FieldChange<String> = .unchanged) {
            self.id = id
            self.name = name
        }
    }
}
