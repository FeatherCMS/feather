public import FeatherApplication
public import FeatherDomain
public import SystemModule

extension Variable.Edit {
    public struct Input: DTO {
        public let id: String
        public let key: FieldChange<String>
        public let value: FieldChange<String>
        public let name: OptionalFieldChange<String>
        public let notes: OptionalFieldChange<String>

        public init(
            id: String,
            key: FieldChange<String> = .unchanged,
            value: FieldChange<String> = .unchanged,
            name: OptionalFieldChange<String> = .unchanged,
            notes: OptionalFieldChange<String> = .unchanged
        ) {
            self.id = id
            self.key = key
            self.value = value
            self.name = name
            self.notes = notes
        }
    }
}
