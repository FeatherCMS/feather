import FeatherApplication
import NewsletterModule

extension Issue.Schedule {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
