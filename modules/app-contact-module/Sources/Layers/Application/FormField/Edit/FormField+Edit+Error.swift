public import FeatherApplication
public import ContactModule

extension FormField.Edit {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
