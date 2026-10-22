public import FeatherApplication
import NewsletterModule

extension Campaign.Add {
    public struct Input: DTO {
        public let key: String
        public let name: String
        public let fromEmail: String

        public init(
            key: String,
            name: String,
            fromEmail: String = ""
        ) {
            self.key = key
            self.name = name
            self.fromEmail = fromEmail
        }
    }
}
