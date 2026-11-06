public import FeatherApplication
public import WebModule

extension Page.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
