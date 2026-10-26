public import ContactModule
public import FeatherApplication

extension FormField.Edit {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }
}
