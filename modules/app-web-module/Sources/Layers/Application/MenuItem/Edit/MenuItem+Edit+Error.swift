public import FeatherApplication
public import WebModule

extension MenuItem.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
