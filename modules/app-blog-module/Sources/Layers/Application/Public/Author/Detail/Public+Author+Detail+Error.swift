import BlogModule
public import FeatherApplication

extension Public.Author.Detail {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
