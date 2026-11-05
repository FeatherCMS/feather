public import FeatherApplication
public import FeatherDomain
public import MediaModule

extension Variant.Edit {
    public struct Input: DTO {
        public let id: String
        public let key: FieldChange<String>
        public let name: FieldChange<String>
        public let isRequired: FieldChange<Bool>
        public let isActive: FieldChange<Bool>

        public init(
            id: String,
            key: FieldChange<String> = .unchanged,
            name: FieldChange<String> = .unchanged,
            isRequired: FieldChange<Bool> = .unchanged,
            isActive: FieldChange<Bool> = .unchanged
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.isRequired = isRequired
            self.isActive = isActive
        }
    }
}
