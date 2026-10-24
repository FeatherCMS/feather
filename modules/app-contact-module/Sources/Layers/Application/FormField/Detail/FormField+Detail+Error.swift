public import FeatherApplication
public import ContactModule

extension FormField.Detail {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
