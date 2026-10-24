public import FeatherApplication
public import FeatherDomain
public import NewsletterModule

extension Campaign.Edit {
    public struct Input: DTO {
        public let key: String
        public let newKey: FieldChange<String>
        public let name: FieldChange<String>
        public let fromEmail: FieldChange<String>

        public init(
            key: String,
            newKey: FieldChange<String>,
            name: FieldChange<String>,
            fromEmail: FieldChange<String>
        ) {
            self.key = key
            self.newKey = newKey
            self.name = name
            self.fromEmail = fromEmail
        }
    }
}
