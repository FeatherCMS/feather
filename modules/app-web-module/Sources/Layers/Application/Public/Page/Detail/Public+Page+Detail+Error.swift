public import FeatherApplication

extension Public.Page.Detail.UseCase {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
