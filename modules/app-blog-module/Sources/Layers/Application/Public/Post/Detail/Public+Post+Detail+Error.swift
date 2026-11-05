import BlogModule
public import FeatherApplication

extension Public.Post.Detail {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
