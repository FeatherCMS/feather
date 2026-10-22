public import FeatherApplication
import NewsModule

extension GetPublicCategory {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
