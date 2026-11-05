public import FeatherApplication
public import WebModule

extension Metadata.Edit {
    public struct Error: UseCaseError {
        public let message: String
    }
}
