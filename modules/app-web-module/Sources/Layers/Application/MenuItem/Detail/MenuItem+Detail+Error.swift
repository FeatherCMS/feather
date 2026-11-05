public import FeatherApplication
public import WebModule

extension MenuItem.Detail {
    public struct Error: UseCaseError {
        public let message: String
    }
}
