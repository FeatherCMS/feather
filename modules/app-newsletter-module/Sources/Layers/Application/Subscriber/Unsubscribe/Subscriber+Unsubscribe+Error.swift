import FeatherApplication
import NewsletterModule

extension Subscriber.Unsubscribe {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
