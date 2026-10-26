public import FeatherApplication
import BlogModule

extension Public.Tag.Detail {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
