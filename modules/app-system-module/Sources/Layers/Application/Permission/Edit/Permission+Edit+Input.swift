public import SystemModule
public import FeatherApplication
public import FeatherDomain

extension Permission.Edit {
    public struct Input: FeatherApplication.DTO {
        public let id: String
        public let key: FieldChange<String>
        public let name: OptionalFieldChange<String>
        public let notes: OptionalFieldChange<String>

        public init(
            id: String,
            key: FieldChange<String> = .unchanged,
            name: OptionalFieldChange<String> = .unchanged,
            notes: OptionalFieldChange<String> = .unchanged
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}
