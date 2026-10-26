public import FeatherApplication
public import FeatherDomain
public import UserModule

extension Role.Edit {
    public struct Input: DTO {
        public let id: String
        public let name: OptionalFieldChange<String>
        public let notes: OptionalFieldChange<String>

        public init(
            id: String,
            name: OptionalFieldChange<String> = .unchanged,
            notes: OptionalFieldChange<String> = .unchanged
        ) {
            self.id = id
            self.name = name
            self.notes = notes
        }
    }
}
