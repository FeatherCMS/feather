public import FeatherApplication
import NewsletterModule

extension Campaign.Remove {
    public struct Input: DTO {
        public let keys: [String]

        public init(keys: [String]) {
            self.keys = keys
        }
    }
}
