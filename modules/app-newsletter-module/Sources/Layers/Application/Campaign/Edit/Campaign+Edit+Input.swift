public import FeatherApplication
public import NewsletterModule

extension Campaign.Edit {
    public struct Input: DTO {
        public let key: String
        public let newKey: String
        public let name: String
        public let fromEmail: String

        public init(
            key: String,
            newKey: String,
            name: String,
            fromEmail: String
        ) {
            self.key = key
            self.newKey = newKey
            self.name = name
            self.fromEmail = fromEmail
        }
    }
}
