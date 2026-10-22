public import FeatherApplication
import WebModule

extension WebRoute.Resolve.UseCase {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
