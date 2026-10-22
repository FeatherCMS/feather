import FeatherApplication
import NewsletterModule

extension Subscriber.Remove {
    public struct Output: DTO {
        public let keys: [String]

        public init(keys: [String]) {
            self.keys = keys
        }
    }
}
