public import FeatherApplication
public import WebModule

extension Metadata.Edit.UseCase {
    public struct Error: UseCaseError {
        public let message: String
    }
}
