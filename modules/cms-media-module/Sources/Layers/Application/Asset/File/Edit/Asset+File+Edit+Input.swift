public import FeatherApplication
public import FeatherDomain
public import MediaModule

extension Asset.File.Edit {
    public struct Input: DTO {
        public let id: String
        public let name: FieldChange<String>
        public let title: OptionalFieldChange<String>
        public let altText: OptionalFieldChange<String>

        public init(
            id: String,
            name: FieldChange<String> = .unchanged,
            title: OptionalFieldChange<String> = .unchanged,
            altText: OptionalFieldChange<String> = .unchanged
        ) {
            self.id = id
            self.name = name
            self.title = title
            self.altText = altText
        }
    }
}
