public import FeatherApplication
public import NewsletterModule

extension Subscriber.Unsubscribe {
    public struct Input: DTO {
        public let token: String

        public init(token: String) {
            self.token = token
        }
    }
}
