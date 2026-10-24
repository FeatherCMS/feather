public import FeatherApplication
public import NewsletterModule

extension Subscriber.Detail {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
