public import FeatherApplication
import BlogModule

extension Public.Post.Detail.UseCase {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
