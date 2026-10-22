public import FeatherApplication
import BlogModule

extension Public.Tag.Detail.UseCase {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
