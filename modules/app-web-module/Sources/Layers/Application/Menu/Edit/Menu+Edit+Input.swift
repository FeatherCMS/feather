public import FeatherApplication
public import FeatherDomain
public import WebModule

extension Menu.Edit {
    public struct Input: DTO {
        public let id: String
        public let key: FieldChange<String>
        public let name: FieldChange<String>
        public let notes: OptionalFieldChange<String>

        public init(
            id: String,
            key: FieldChange<String>,
            name: FieldChange<String>,
            notes: OptionalFieldChange<String>
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}
