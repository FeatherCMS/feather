public import FeatherApplication
public import WebModule

extension Page.Detail {
    public struct Error: UseCaseError {
        public let message: String
    }
}
