public import FeatherApplication

extension WebRoute.Resolve {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
